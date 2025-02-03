part of '../spotify.dart';

/// A search result from Spotify.
class SpotifyResult extends Result {
  @override
  final List<String> artists;

  @override
  final String title;

  @override
  final String album;

  @override
  final int sDuration;

  @override
  final String url;

  @override
  final TokenSrc source;

  /// Creates a new [SpotifyResult].
  SpotifyResult({
    required this.artists,
    required this.title,
    required this.album,
    required this.sDuration,
    required this.url,
    required this.source,
  });
}
