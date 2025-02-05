part of '../download.dart';

/// Run background downloads in a separate process.
///
/// ### Notes
///
/// - Process goes like this: `initialize` ---> `_isolateSetup` --event-loop--> `_downloadFile`
/// --event-loop--> `_isolateSetup` --> `verifyRequestProcessing`.
class DownloadProcess {
  /// Port to send data to the spawned Isolate.
  final SendPort _toSpawnedIsolate;

  /// Port to receive data from the spawned Isolate.
  final ReceivePort _fromSpawnedIsolate;

  /// A *ledger* of unprocessed download requests.
  final _activeRequests = <int, Completer<void>>{};

  /// Shutdown code for the spawned Isolate.
  static const _shutdownCode = '5hu†d0wn';

  /// Index for request id.
  int _idIndex = 0;

  /// Flag to check if the spawned Isolate is closed.
  bool _isClosed = false;

  /// Create the "actual" [DownloadProcess] instance, switch from static isolate logic to instance logic
  /// for processing verification.
  DownloadProcess._(this._toSpawnedIsolate, this._fromSpawnedIsolate) {
    var _ = _fromSpawnedIsolate.listen(_verifyRequestProcessing);
  }

  /// Create a [DownloadProcess] instance.
  ///
  /// ### Note
  /// - We do this in a static method as constructors can't be async.
  static Future<DownloadProcess> initialize() async {
    // Completer as lock to ensure that the spawned Isolate's SendPort is not used before it's
    // exchanged with the main Isolate.
    //
    // NOTE: (ReceivePort, SendPort) is a `Record` type, you might want to look it up on dart.dev.
    //
    // NOTE: A Completer is a Future that can be completed manually, this is important when you
    // consider the async priority order in Dart as follows:
    //
    //    1. Sync  Task                     > Synchronous code, executes first
    //
    //    2. Micro Task                     > high priority async code, executes after sync code
    //                                      usually for things like updating app state, created via
    //                                      `ScheduleMicrotask` / `Completer` / etc.
    //
    //    3. Macro Task / Event Loop Task   > low priority async code, executes after microtasks
    //                                      usually for things like I/O & http requests, created via
    //                                     `Future` / `Stream` / etc.
    //
    // NOTE: A Completer.sync() is essentially a task that is sent to the top of the microtask
    // queue, a.k.a an async task  executed as soon as possible (potentially even synchronously).
    // We use this here to minimize Isolate initialization time.
    final connectionLock = Completer<(ReceivePort, SendPort)>.sync();

    // Create a RawReceivePort (as we can set a different handler when we convert it to a
    // ReceivePort later) and add in the connectionLock logic.
    final initializationPort = RawReceivePort();
    initializationPort.handler = (toSpawnedIsolatePort) {
      connectionLock.complete(
        (
          ReceivePort.fromRawReceivePort(initializationPort),
          toSpawnedIsolatePort as SendPort,
        ),
      );
    };

    // Spawn worker Isolate, on literally any error close the initializationPort and rethrow.
    try {
      var _ = await Isolate.spawn(_isolateSetup, initializationPort.sendPort);
    } on Object {
      initializationPort.close();
      rethrow;
    }

    // Wait for the connectionLock to complete, then return the ReceivePort and SendPort.
    final (ReceivePort fromIsolatePort, SendPort toIsolatePort) = await connectionLock.future;

    // Create a Downloader instance and return it.
    return DownloadProcess._(toIsolatePort, fromIsolatePort);
  }

  /// Add a url to the download queue.
  ///
  /// ### Returns
  /// - A [Completer] that completes when the download is done.
  ///
  /// ### Note
  /// - Operates on the Main Isolate
  Future<Completer<void>> addToDownloadQueue(String url, String filePath) async {
    // If Spawned Isolate is closed, throw an error.
    if (_isClosed) {
      throw StateError('Downloader is closed');
    }

    // This completer is used to ensure that the spawned Isolate has processed the request,
    // and that a request is removed from the activeRequests map only after download.
    // It is completed in _verifyRequestProcessing.
    final activeRequestsLock = Completer<void>.sync();
    final id = _idIndex++;

    _activeRequests[id] = activeRequestsLock;
    _toSpawnedIsolate.send((id, url, filePath));

    return activeRequestsLock;
  }

  /// Shuts down the Downloader.
  void shutdown() {
    if (!_isClosed) {
      _isClosed = true;
      _toSpawnedIsolate.send(_shutdownCode);

      // NOTE: _activeRequests only has requests that are sent, but not yet processed. So, if there
      // is a request being processed, while shutdown is called, it will be processed and when it is
      // returned, the _fromSpawnedIsolate port will be closed in _verifyRequestProcessing.
      if (_activeRequests.isEmpty) {
        _fromSpawnedIsolate.close();
      }
    }
  }

  /// Setup an Isolate, it's event-loop, and exchange Send/Receive Ports with the main Isolate.
  ///
  /// ### Note
  /// - Returns request id on successful download, [RemoteError] on error.
  static void _isolateSetup(SendPort toMainIsolate) {
    // Exchange Send/Receive Ports with the main Isolate.
    final fromMainIsolate = ReceivePort();
    toMainIsolate.send(fromMainIsolate.sendPort);

    // Setup step. The Spawned Isolate inside of which this is running has no "global state" where
    // you can store the httpClient for re-use, creating it within the _downloadTrack function would
    // recreate it for every request, so we create it here, and pass it down to _downloadTrack
    // each time a request is made.
    var httpClient = HttpClient();

    // Spawned Isolate event-loop.
    var _ = fromMainIsolate.listen((message) {
      // Shutdown handling.
      if (message == DownloadProcess._shutdownCode) {
        httpClient.close();
        fromMainIsolate.close();

        // NOTE: Exits event-loop. Kills Isolate.
        return;
      }

      // Destructuring message data. Format is pre-determined.
      final (int id, String url, String filePath) = message;

      // Processing.
      try {
        // ignore: prefer-async-await, converting async code to sync for Isolate.listen callback.
        _downloadFile(url, filePath, httpClient).then((value) {
          toMainIsolate.send(id);
        });
      } catch (e) {
        toMainIsolate.send(RemoteError(e.toString(), ''));
      }
    });
  }

  /// Download File from URL.
  static Future<void> _downloadFile(
    String url,
    String filePath,
    HttpClient httpClient,
  ) async {
    // Request-Response.
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    // Buffer and write data to file.
    // NOTE: 1024 * 1024 = 1MB, BufferSize is 3MB. We use a custom buffer as the default is ~8kB,
    // 8kB requires way too many write calls.
    var bufferSize = 1 * 1024 * 1024;
    var cBufferSize = 0;
    var buffer = <List<int>>[];

    // Streaming the response to file.

    if (response.statusCode == HttpStatus.ok) {
      var file = File(filePath);
      var fileSink = file.openWrite();

      await for (var chunk in response) {
        cBufferSize += chunk.length;
        buffer.add(chunk);

        if (cBufferSize >= bufferSize) {
          // Consolidate chunks & write to file.
          var expandedBuffer = buffer.expand((e) => e).toList();
          fileSink.add(expandedBuffer);

          // Reset buffer.
          buffer.clear();
          cBufferSize = 0;
        }
      }

      // Consolidate chunks & write any leftover data in buffer to file.
      var expandedBuffer = buffer.expand((e) => e).toList();
      fileSink.add(expandedBuffer);

      // Cleanup.
      var _ = await fileSink.flush();
      _ = await fileSink.close();
    }
  }

  /// Verify that a request has been processed by the spawned Isolate & related cleanup.
  void _verifyRequestProcessing(message) {
    // Extract requestId.
    final id = message as int;

    // Remove request, verify completion. See last line of `addToDownloadQueue`.
    _activeRequests.remove(id)!.complete();

    // If Downloader is not accepting new requests, and existing requests are processed, close.
    if (_isClosed && _activeRequests.isEmpty) {
      _fromSpawnedIsolate.close();
    }
  }
}
