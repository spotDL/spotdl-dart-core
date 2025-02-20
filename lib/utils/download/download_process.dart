part of '../download.dart';

class DownloadProcess implements Process<(int, String, String), void, HttpClient> {
  final Process<(int, String, String), void, HttpClient> _process;

  @override
  bool get isActive => _process.isActive;

  @override
  Future<void> Function((int, String, String) input, HttpClient setupRecord) get processInput =>
      _downloadFile;

  @override
  Future<void> get processingIsComplete => _process.processingIsComplete;

  @override
  Future<HttpClient> Function() get setupProcess => _createClient;

  @override
  String get shutdownCode => _process.shutdownCode;

  @override
  Future<void> Function(HttpClient commonResourceRecord) get shutdownProcess => _closeClient;

  DownloadProcess._(this._process);

  /// Initialize the [DownloadProcess] instance.
  static Future<DownloadProcess> boot() async {
    final process = await Process.boot<(int, String, String), void, HttpClient>(
      _createClient,
      _downloadFile,
      _closeClient,
    );

    return DownloadProcess._(process);
  }

  /// Adds a URL to the download queue. (bg-proc).
  Future<void> addToDownloadQueue(String url, String filePath, [int bufferSizeInMb = 3]) async {
    return _process.process((bufferSizeInMb, url, filePath));
  }

  @override
  Future<void> process((int, String, String) input) {
    return _process.process(input);
  }

  @override
  Future<void> shutdownNow() {
    return _process.shutdownNow();
  }

  @override
  Future<void> shutdownOnCompletion() {
    return _process.shutdownOnCompletion();
  }

  /// Setup: See [Process.setupProcess].
  static Future<HttpClient> _createClient() async {
    return HttpClient();
  }

  /// Clean up: See [Process.shutdownProcess].
  static Future<void> _closeClient(HttpClient client) async {
    client.close();
  }

  /// Process input: See [Process.processInput]. Download File from URL.
  static Future<void> _downloadFile(
    (int, String, String) urlLoc,
    HttpClient httpClient,
  ) async {
    // Destructure input.
    var (bufferSizeInMb, url, filePath) = urlLoc;

    // Request-Response.
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    // Buffer and write data to file.
    // NOTE: 1024 * 1024 = 1MB, BufferSize is 3MB. We use a custom buffer as the default is ~8kB,
    // 8kB requires way too many write calls.
    var bufferSize = bufferSizeInMb * 1024 * 1024;
    var buffer = <int>[];

    // Streaming the response to file.
    var exitLock = Completer<void>.sync();

    if (response.statusCode == HttpStatus.ok) {
      var file = File(filePath);
      var fileSink = file.openWrite();

      var _ = response.listen(
        (chunk) {
          buffer.addAll(chunk);

          if (buffer.length >= bufferSize) {
            // Consolidate chunks & write to file.
            fileSink.add(buffer);

            // Reset buffer.
            buffer.clear();
          }
        },
        onDone: () {
          // Consolidate chunks & write any leftover data in buffer to file.
          fileSink.add(buffer);

          // Cleanup.
          var _ = fileSink.flush().then((value) {
            var _ = fileSink.close();

            exitLock.complete();
          });
        },
      );
    }

    return exitLock.future;
  }
}
