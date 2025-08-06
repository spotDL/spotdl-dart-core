import 'dart:async';

import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube.dart';
import 'package:spotdl_dart_core/utils.dart';

void main(List<String> args) async {
  var spS = SpotifyEngine();
  var ytS = YoutubeEngine();
  var dlM = await DownloadManager.boot();

  for (var query in [
    'Remember The Name Fort Minor',
    'STRUT The Struts',
    'Rasputin Boney M.',
    'Blinding Lights The Weeknd',
    'Shape of You Ed Sheeran',
    'Uptown Funk Mark Ronson',
    'Rolling in the Deep Adele',
    'Someone Like You Adele',
    'Bad Guy Billie Eilish',
    'Old Town Road Lil Nas X',
    'Senorita Shawn Mendes',
    'Dance Monkey Tones and I',
    'Rockstar Post Malone',
    'One Dance Drake',
    'Closer The Chainsmokers',
    'Girls Like You Maroon 5',
    'Havana Camila Cabello',
    'Despacito Luis Fonsi',
    'Sorry Justin Bieber',
    'Roar Katy Perry',
    'Happy Pharrell Williams',
    'All About That Bass Meghan Trainor',
  ]) {
    var startTime = DateTime.now();

    unawaited(
      spS.searchForTrack(query).then(
        (resultList) {
          resultList.first.toResult().then(
            (resultResolved) {
              print('$resultResolved (${resultList.isNotEmpty})');
              ytS.searchForTrackFromResult(resultResolved).then(
                (resultList) {
                  resultList.first.toResult().then(
                    (resultResolved) {
                      print('$resultResolved (${resultList.isNotEmpty})');
                      dlM.process(resultResolved).then(
                        (successState) {
                          print(
                            '[$successState] ${resultResolved.title} by ${resultResolved.artists.join(', ')}\n${startTime.difference(DateTime.now()).inMilliseconds} ms',
                          );
                        },
                      );
                    },
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
