import 'package:spotdl_dart_core/providers/youtube.dart';

void main(List<String> args) async {
  var ytS = YoutubeEngine();

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
    await ytS.searchForTrack(query).then((resultList) => resultList.forEach(print));
  }
}
