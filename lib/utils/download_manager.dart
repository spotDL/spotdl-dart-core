part of '../utils.dart';

class DownloadManager {
  final ProcessGroup<Result, bool, HttpClient> _processGroup;

  Future<void> get processingIsComplete => _processGroup.processingIsComplete;

  DownloadManager._(this._processGroup);

  static Future<DownloadManager> boot([int processCount = 0]) async {
    var processGroup = await ProcessGroup.boot<Result, bool, HttpClient>(
      setupProcess,
      processInput,
      shutdownProcess,
      processCount == 0 ? Platform.numberOfProcessors : processCount,
    );

    return DownloadManager._(processGroup);
  }

  @override

  /// Returns `true` if the input was successfully downloaded.
  Future<bool> process(Result input) {
    return _processGroup.process(input);
  }

  @override
  Future<void> shutdownNow() {
    return _processGroup.shutdownNow();
  }

  @override
  Future<void> shutdownOnCompletion() {
    return _processGroup.shutdownOnCompletion();
  }

  static Future<HttpClient> setupProcess() async {
    return HttpClient();
  }

  static Future<bool> processInput(Result song, HttpClient client) async {
    var completer = Completer<bool>.sync();

    var filePath = '${song.artists.join(', ')} - ${song.title}';

    for (var type in ['.mp3', '.jpg']) {
      try {
        var t1 = DateTime.timestamp();

        var file = File(filePath);
        var sink = file.openWrite();

        var t2 = DateTime.timestamp();

        var httpRequest = await client.getUrl(Uri.parse(type == '.mp3' ? song.dlUrl : song.artUrl));

        var t3 = DateTime.timestamp();

        var httpResponse = await httpRequest.close();

        var t4 = DateTime.timestamp();

        var httpBody = await httpResponse.pipe(sink);

        var t5 = DateTime.timestamp();

        await sink.flush();
        await sink.close();

        var t6 = DateTime.timestamp();

        print('    fileOpen: ${t2.difference(t1).inMilliseconds}ms');
        print(' httpRequest: ${t3.difference(t2).inMilliseconds}ms');
        print('httpResponse: ${t4.difference(t3).inMilliseconds}ms');
        print('httpBodyPipe: ${t5.difference(t4).inMilliseconds}ms');
        print('   fileClose: ${t6.difference(t5).inMilliseconds}ms');
      } on Exception {
        completer.complete(false);
      }
    }

    completer.complete(true);

    return completer.future;
  }

  static Future<void> shutdownProcess(HttpClient commonResourceRecord) async {
    return commonResourceRecord.close();
  }
}
