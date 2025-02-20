import 'dart:async';

import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube.dart';
import 'package:spotdl_dart_core/utils.dart';

void main(List<String> args) async {
  var spS = SpotifyEngine();
  var ytS = YoutubeEngine();
  var dlM = await DownloadManager.boot();

  for (var query in [
    'Remember The Name Song',
    'STRUT Song',
    'Rasputin Song',
    'Blinding Lights Song',
    'Shape of You Song',
    'Uptown Funk Song',
    'Rolling in the Deep Song',
    'Someone Like You Song',
    'Bad Guy Song',
    'Old Town Road Song',
    'Senorita Song',
    'Dance Monkey Song',
    'Rockstar Song',
    'One Dance Song',
    'Closer Song',
    'Girls Like You Song',
    'Havana Song',
    'Despacito Song',
    'Sorry Song',
    'Roar Song',
    'Happy Song',
    'All About That Bass Song',
  ]) {
    unawaited(
      spS.searchForTrack(query).then(
        (resultList) {
          ytS.searchForTrackFromResult(resultList.first).then(
            (resultList) {
              dlM.process(resultList.first).then(
                (successState) {
                  print(
                    '[$successState] ${resultList.first.title} by ${resultList.first.artists.join(', ')}',
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
