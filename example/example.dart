import 'dart:io';

import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube_music.dart';
import 'package:spotdl_dart_core/utils/download.dart';

void main(List<String> args) async {
  var dl = await DownloadManager.initialize(Platform.numberOfProcessors);
  // var dl = await DownloadManager.initialize(4);

  var yt = await YoutubeMusicEngine.create();
  var sp = SpotifyEngine();

  var input = '';

  // var queries = ['ynir danheim', 'exit'];

  while (input != 'exit') {
    stdout.write('query: ');
    input = stdin.readLineSync() ?? '';
    // input = queries.removeAt(0);

    if (input == 'exit') {
      break;
    } else if (input == '') {
      continue;
    } else {
      print('[info] Searching for track on Spotify\n');

      var spRes = (await sp.searchForTrack(input, 1)).first;
      print(spRes);

      print('\n${'-' * 100}\n');

      print('[info] Searching for track on YouTubeMusic\n');

      List<YoutubeMusicResult> ytMatches;

      ytMatches = await yt.searchForTrackFromResult(spRes);

      if (ytMatches.isEmpty) {
        print('[info] No matches found on YouTubeMusic\n');
        continue;
      }

      print('[info] Locating best match by duration\n');

      var bestMatch = ytMatches.first;

      for (var ytRes in ytMatches) {
        if ((ytRes.sDuration - spRes.sDuration).abs() <
            (bestMatch.sDuration - spRes.sDuration).abs()) {
          bestMatch = ytRes;
        }
      }

      print('-' * 100);
      print('$bestMatch\n');
      print('-' * 100);

      var fileTitle = '${spRes.artists.join(', ')} - ${spRes.title}';

      print('[info] Adding albumArt/webaFile to download queue\n');

      var artCompleter = await dl.addToDownloadQueue(spRes.artUrl, './$fileTitle.jpg');
      var soundCompleter = await dl.addToDownloadQueue(bestMatch.dlUrl, './$fileTitle.weba');

      artCompleter.future.then((v) => print('[info] $fileTitle albumArt Downloaded]\n'));
      soundCompleter.future.then((v) => print('[info] $fileTitle WebaFile Downloaded]\n'));
    }
  }

  dl.shutdown();
}
