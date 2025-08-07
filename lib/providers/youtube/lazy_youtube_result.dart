part of '../youtube.dart';

/// A search result from YouTube.
class LazyYouTubeResult extends LazyResult {
  final Stream<String> Function() _artists;

  final Future<String> Function() _title;

  final Future<String> Function() _album;

  final Future<int> Function() _sDuration;

  final Future<String> Function() _srcUrl;

  final Future<String> Function() _dlUrl;

  final Future<String> Function() _artUrl;

  final Future<Source> Function() _source;

  LazyYouTubeResult({
    required Stream<String> Function() artists,
    required Future<String> Function() title,
    required Future<String> Function() album,
    required Future<int> Function() sDuration,
    required Future<String> Function() srcUrl,
    required Future<String> Function() dlUrl,
    required Future<String> Function() artUrl,
    required Future<Source> Function() source,
  })  : _artists = artists,
        _title = title,
        _album = album,
        _sDuration = sDuration,
        _srcUrl = srcUrl,
        _dlUrl = dlUrl,
        _artUrl = artUrl,
        _source = source;

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
  Future<Source> source() => _source();

  @override
  Future<String> srcUrl() => _srcUrl();

  @override
  Future<String> title() => _title();

  @override
  Future<Result> toResult() async => YouTubeResult(
        artists: await _artists().toList(),
        title: await _title(),
        album: await _album(),
        sDuration: await _sDuration(),
        srcUrl: await _srcUrl(),
        dlUrl: await _dlUrl(),
        artUrl: await _artUrl(),
        source: await _source(),
      );
}
