import 'dart:io';

import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube.dart';
import 'package:spotdl_dart_core/utils/download.dart';

void main(List<String> args) async {
  var dl = await DownloadManager.initialize(Platform.numberOfProcessors);

  var yt = YoutubeEngine();
  var sp = SpotifyEngine();

  var input = '';

  while (input != 'exit') {
    stdout.write('query: ');
    input = stdin.readLineSync() ?? '';

    if (input == 'exit') {
      break;
    } else if (input == '') {
      continue;
    } else {
      print('[info] Searching for track on Spotify\n');

      var spRes = (await sp.searchForTrack(input, 1)).first;
      print(spRes);

      print('\n${'-' * 100}\n');

      print('[info] Searching for track on YouTube\n');

      var ytQry = await yt.constructSearchQuery(spRes);
      List<YouTubeResult> ytMatches;

      while (true) {
        try {
          ytMatches = await yt.searchForTrack(ytQry);
          break;
        } on Object {
          print('[info] Re-attempting Search on YouTube\n');
          continue;
        }
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

      await dl
          .addToDownloadQueue(spRes.artUrl, './$fileTitle.jpg')
          .then((v) => print('[info] $fileTitle albumArt Downloaded'));
      await dl
          .addToDownloadQueue(bestMatch.dlUrl!, './$fileTitle.weba')
          .then((v) => print('[info] $fileTitle WebaFile Downloaded'));
    }
  }

  dl.shutdown();
}
