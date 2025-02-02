import 'dart:io';

import 'package:spotdl_dart_core/provider/spotify.dart';

void main(List<String> args) async {
  var se = SpotifyEngine();

  var input = '';

  while (input != 'exit') {
    stdout.write('query: ');
    input = stdin.readLineSync() ?? '';

    if (input == 'exit') {
      break;
    } else if (input == '') {
      continue;
    } else {
      print('');

      var results = await se.searchForTrack(input);
      results.forEach(print);
    }
  }
}
