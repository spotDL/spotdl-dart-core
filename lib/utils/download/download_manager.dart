part of '../download.dart';

/// Manages multiple sub-processes for distributed downloads.
class DownloadManager implements ParallelizationInterface<(int, String, String), void, HttpClient> {
  final List<DownloadProcess> _processes;

  int _cProcess = 0;

  final Completer<void> _processingCompletionLock = Completer<void>();

  DownloadManager._(this._processes);

  static Future<DownloadManager> boot(int processCount) async {
    var processes = <DownloadProcess>[];

    for (var i = 0; i < processCount; i++) {
      processes.add(await DownloadProcess.boot());
    }

    return DownloadManager._(processes);
  }

  @override
  Future<void> Function((int, String, String) input, HttpClient commonResourceRecord)
      get processInput => _processes.first.processInput;

  @override
  Future<void> get processingIsComplete => _processingCompletionLock.future;

  @override
  Future<HttpClient> Function() get setupProcess => _processes.first.setupProcess;

  @override
  Future<void> Function(HttpClient commonResourceRecord) get shutdownProcess =>
      _processes.first.shutdownProcess;

  /// Adds a URL to the download queue. (bg-proc).
  Future<void> addToDownloadQueue(String url, String filePath, [int bufferSizeInMb = 3]) async {
    return _processes[_cProcess++].process((bufferSizeInMb, url, filePath));
  }

  @override
  Future<void> process((int, String, String) input) {
    return _processes[_cProcess++].process(input);
  }

  @override
  Future<void> shutdownNow() async {
    for (var proc in _processes) {
      await proc.shutdownNow();
    }

    _processingCompletionLock.complete();
  }

  @override
  Future<void> shutdownOnCompletion() async {
    for (var proc in _processes) {
      await proc.shutdownOnCompletion();

      unawaited(
        proc.processingIsComplete.then((_) {
          var _ = _processes.remove(proc);

          if (_processes.isEmpty) {
            _processingCompletionLock.complete();
          }
        }),
      );
    }
  }
}
