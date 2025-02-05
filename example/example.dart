import 'dart:io';

import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube.dart';
import 'package:spotdl_dart_core/utils/download.dart';

void main(List<String> args) async {
  var yt = YoutubeEngine();
  var sp = SpotifyEngine();
  var dl = await Downloader.initialize();

  var input = '';

  while (input != 'exit') {
    stdout.write('query: ');
    input = stdin.readLineSync() ?? '';

    if (input == 'exit') {
      break;
    } else if (input == '') {
      continue;
    } else {
      var spRes = (await sp.searchForTrack(input, 1)).first;
      print(spRes);

      print('\n${'-' * 150}\n');

      var ytQry = await yt.constructSearchQuery(spRes);
      List<YouTubeResult> ytMatches;

      while (true) {
        try {
          ytMatches = await yt.searchForTrack(ytQry);
          break;
        } on UnimplementedError {
          print('rerun [yt_explod_bug]');
          continue;
        }
      }

      var bestMatch = ytMatches.first;

      for (var ytRes in ytMatches) {
        print('$ytRes\n');

        if ((ytRes.sDuration - spRes.sDuration).abs() <
            (bestMatch.sDuration - spRes.sDuration).abs()) {
          bestMatch = ytRes;
        }
      }

      print('-' * 150);
      print('$bestMatch\n');
      print('-' * 150);

      var fileTitle = '${spRes.artists.join(', ')} - ${spRes.title}';

      await dl.addToDownloadQueue(spRes.artUrl, './$fileTitle.jpg');
      await dl.addToDownloadQueue(bestMatch.dlUrl!, './$fileTitle.weba');
    }
  }
}
