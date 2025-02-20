import 'dart:async';
import 'dart:io';

import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube_music.dart';
import 'package:spotdl_dart_core/utils/download.dart';

void main(List<String> args) async {
  args = ['test-static'];
  if (args.isEmpty) {
    print(
      'Please provide an argument. Use "example.exe benchmark", "example.exe test-dynamic", or "example.exe test-static"',
    );
  } else if (args.first == 'benchmark') {
    await downloadTest();
  } else if (args.first == 'test-dynamic' || args.first == 'test-static') {
    var processCount = 4;

    var initTime = DateTime.timestamp();

    var spEngine = SpotifyEngine();
    var spInit = DateTime.timestamp().difference(initTime).inMilliseconds;

    var ytEngine = await YoutubeMusicEngine.initialize();
    var ytInit = DateTime.timestamp().difference(initTime).inMilliseconds;

    var dlEngine = await DownloadManager.initialize(processCount);
    var dlInit = DateTime.timestamp().difference(initTime).inMilliseconds;

    print(
      '${'spEngine [$spInit ms]'.padRight(35)} ${'ytEngine [$ytInit ms]'.padRight(18).padLeft(36)} ${'dlEngine($processCount) [$dlInit ms]'.padLeft(35)}\n',
    );

    if (args.first == 'test-dynamic') {
      String query;

      while (true) {
        stdout.write('QRY: ');
        query = stdin.readLineSync() ?? '';

        if (query == 'exit') {
          break;
        }

        try {
          await downloadSongAndAlbumArt(query, spEngine, ytEngine, dlEngine);
        } on StateError catch (e) {
          if (e.message == 'No element') {
            print(
              '${'ERR: Could not find a match for "$query", try a different query.'.padRight(91)} [${DateTime.timestamp().difference(initTime).inMilliseconds.toString().padLeft(6)} ms]',
            );
          } else {
            rethrow;
          }
        }
      }
    } else {
      for (var query in [
        'limited edition hael',
        'raggamuffin koffee',
        'ymir danheim',
        'last of us',
        'strut',
        'duel of fates',
        'you are the jump master',
        'tetris',
      ]) {
        try {
          await downloadSongAndAlbumArt(query, spEngine, ytEngine, dlEngine);
        } on StateError catch (e) {
          if (e.message == 'No element') {
            print(
              '${'ERR: Could not find a match for "$query", try a different query.'.padRight(91)}[${DateTime.timestamp().difference(initTime).inMilliseconds.toString().padLeft(6)} ms]',
            );
          } else {
            rethrow;
          }
        }
      }
    }

    dlEngine.shutdown();
  } else {
    print(
      'Invalid argument. Use "example.exe benchmark", "example.exe test-dynamic", or "example.exe test-static"',
    );
  }
}

Future<void> downloadSongAndAlbumArt(
  String searchQuery,
  SpotifyEngine spEngine,
  YoutubeMusicEngine ytEngine,
  DownloadManager dlEngine,
) async {
  var initTime = DateTime.timestamp();

  var results = await spEngine.searchForTrack(searchQuery);
  print(
    'SRC: ${results.first.title.padRight(30)} ${results.first.srcUrl.padRight(60)} [${DateTime.timestamp().difference(initTime).inMilliseconds.toString().padLeft(6)} ms]',
  );

  var matches = await ytEngine.searchForTrackFromResult(results.first);
  print(
    'DLL: ${matches.first.title.padRight(30)} ${matches.first.srcUrl.padRight(60)} [${DateTime.timestamp().difference(initTime).inMilliseconds.toString().padLeft(6)} ms]',
  );

  var audCmplt = await dlEngine.addToDownloadQueue(
    matches.first.dlUrl,
    '${results.first.title}.weba',
  );

  var artCmplt = await dlEngine.addToDownloadQueue(
    results.first.artUrl,
    '${results.first.title}.jpg',
  );

  unawaited(
    // ignore: prefer-async-await, to run print after download.
    audCmplt.future.then(
      (v) => print(
        'AUD: ${results.first.title.padRight(91)} [${DateTime.timestamp().difference(initTime).inMilliseconds.toString().padLeft(6)} ms]',
      ),
    ),
  );

  unawaited(
    // ignore: prefer-async-await, to run print after download.
    artCmplt.future.then(
      (v) => print(
        'ART: ${results.first.title.padRight(91)} [${DateTime.timestamp().difference(initTime).inMilliseconds.toString().padLeft(6)} ms]',
      ),
    ),
  );
}

/// EASILY HITS 8MBPS.
Future<void> downloadTest() async {
  final testDataUrl = 'https://freetestdata.com/wp-content/uploads/2024/05/FLAC_8MB.flac';

  var downloadManager = await DownloadManager.initialize(5);

  var initTime = DateTime.timestamp();

  for (var i = 0; i < 5; i++) {
    var cmplt = await downloadManager.addToDownloadQueue(testDataUrl, 'test$i.flac');

    unawaited(
      // ignore: prefer-async-await, for consistency.
      cmplt.future.then(
        (v) => print(
          'test$i.flac downloaded in ${DateTime.timestamp().difference(initTime).inMilliseconds} ms @ ${(8 / (DateTime.timestamp().difference(initTime).inMilliseconds / 1000)).toStringAsFixed(2)} Mbps',
        ),
      ),
    );
  }

  downloadManager.shutdown();
}
