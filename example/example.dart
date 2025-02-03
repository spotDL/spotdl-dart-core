import 'dart:io';

import 'package:spotdl_dart_core/provider/spotify.dart';
import 'package:spotdl_dart_core/provider/youtube.dart';

void main(List<String> args) async {
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
      var spRes = await sp.searchForTrack(input, 1);
      print(spRes.first);

      print('-' * 150);

      var ytQry = await yt.constructSearchQuery(spRes.first);
      (await yt.searchForTrack(ytQry)).forEach((ytRes) => print('$ytRes\n'));

      print('-' * 150);
    }
  }
}
