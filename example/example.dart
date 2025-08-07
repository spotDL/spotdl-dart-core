import 'package:spotdl_dart_core/providers/spotify.dart';
import 'package:spotdl_dart_core/providers/youtube.dart';
// import 'package:spotdl_dart_core/utils.dart';

void main(List<String> args) async {
  var sEngine = SpotifyEngine();
  var yEngine = YoutubeEngine();
  // var manager = await DownloadManager.boot();

  var sssTime = DateTime.now();

  for (var query in [
    'Remember The Name Fort Minor',
    'Rasputin Boney M.',
    'Blinding Lights The Weeknd',
    'Shape of You Ed Sheeran',
    'Uptown Funk Mark Ronson',
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
    print('Searching for: $query');

    await awaitChainingProc(sssTime, query, sEngine, yEngine);
  }

  sssTime = DateTime.now();

  for (var query in [
    'Remember The Name Fort Minor',
    'Rasputin Boney M.',
    'Blinding Lights The Weeknd',
    'Shape of You Ed Sheeran',
    'Uptown Funk Mark Ronson',
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
    print('Searching for: $query');

    await thenChainProc(sssTime, query, sEngine, yEngine);
  }

  
}
Future<void> thenChainProc(DateTime sssTime, String query, SpotifyEngine sEngine, YoutubeEngine yEngine) async {
    var _ = sEngine.searchForTrack(query, 5).listen((result) {
      var title = '';

      result.title().then((sTitle) {
        title = sTitle;
        result.artists().toList().then(
              (artists) => result.album().then((album) {
                result.srcUrl().then((srcUrl) {
                  print(
                      'Found: $sTitle by ${artists.join(', ')} from album "$album"\n\t$srcUrl\n\t${DateTime.now().difference(sssTime).inMilliseconds}ms\n');
                });
              }),
            );
      });

      yEngine.searchForTrack(query, 5).listen((ytResult) {
        ytResult.title().then(
              (yTitle) => ytResult.artists().toList().then(
                    (yArtists) => ytResult.album().then((yAlbum) {
                      ytResult.srcUrl().then((srcUrl) {
                        print(
                            '\t>$title: $yTitle by ${yArtists.join(', ')} from album "$yAlbum"\n\t\t$srcUrl\n\t\t${DateTime.now().difference(sssTime).inMilliseconds}ms\n');
                      });
                    }),
                  ),
            );
      });
    });
  }

  Future<void> awaitChainingProc(DateTime sssTime, String query, SpotifyEngine sEngine, YoutubeEngine yEngine) async {
    await for (var result in sEngine.searchForTrack(query, 5)) {
      var sTitle = await result.title();
      var artists = await result.artists().toList();
      var album = await result.album();
      var srcUrl = await result.srcUrl();

      print(
          'Found: $sTitle by ${artists.join(', ')} from album "$album"\n\t$srcUrl\n\t${DateTime.now().difference(sssTime).inMilliseconds}ms\n');

      await for (var ytResult in yEngine.searchForTrack(query, 5)) {
        var yTitle = await ytResult.title();
        var yArtists = await ytResult.artists().toList();
        var yAlbum = await ytResult.album();
        var ySrcUrl = await ytResult.srcUrl();

        print(
            '\t>$sTitle: $yTitle by ${yArtists.join(', ')} from album "$yAlbum"\n\t\t$ySrcUrl\n\t\t${DateTime.now().difference(sssTime).inMilliseconds}ms\n');
      }
    }
  }