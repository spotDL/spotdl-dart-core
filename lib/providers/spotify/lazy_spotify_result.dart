part of '../spotify.dart';

class LazySpotifyResult extends LazyResult {
  final int diskNumber;

  final int trackNumber;
  
  final Future<String> Function() _album;

  final Future<String> Function() _artUrl;

  final Stream<String> Function() _artists;

  final Future<String> Function() _dlUrl;

  final Future<int> Function() _sDuration;

  final Future<String> Function() _srcUrl;

  final Future<String> Function() _title;

  LazySpotifyResult({
    required Future<String> Function() album,
    required Future<String> Function() artUrl,
    required Stream<String> Function() artists,
    required Future<String> Function() dlUrl,
    required Future<int> Function() sDuration,
    required Future<String> Function() srcUrl,
    required Future<String> Function() title,
    required this.diskNumber,
    required this.trackNumber,
  })  : _album = album,
        _artUrl = artUrl,
        _artists = artists,
        _dlUrl = dlUrl,
        _sDuration = sDuration,
        _srcUrl = srcUrl,
        _title = title;

  @override
  Future<String> album() => _album();

  @override
  Future<String> artUrl() => _artUrl();

  @override
  Stream<String> artists() => _artists();

  @override
  Future<String> dlUrl() => _dlUrl();

  @override
  Future<int> sDuration() => _sDuration();

  @override
  Future<Source> source() async => Source.spotify;

  @override
  Future<String> srcUrl() => _srcUrl();

  @override
  Future<String> title() => _title();

  @override
  Future<Result> toResult() async => SpotifyResult(
        artists: await artists().toList(),
        title: await title(),
        album: await album(),
        sDuration: await sDuration(),
        srcUrl: await srcUrl(),
        artUrl: await artUrl(),
        source: await source(),
        diskNumber: diskNumber,
        trackNumber: trackNumber,
      );
}
