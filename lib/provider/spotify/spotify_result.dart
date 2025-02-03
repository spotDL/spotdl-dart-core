part of '../spotify.dart';

/// A search result (Track) from Spotify.
///
/// ### Note
///
/// - As Spotify is the *Source of Truth*, [SpotifyResult] has the following extra fields:
///   - [diskNumber]
///   - [trackNumber]
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

  /// The disk number of the track. `1` unless from an multi-disk album.
  final int diskNumber;

  /// The track number of the album disk.
  final int trackNumber;

  /// Creates a new [SpotifyResult].
  SpotifyResult({
    required this.artists,
    required this.title,
    required this.album,
    required this.sDuration,
    required this.url,
    required this.source,
    required this.diskNumber,
    required this.trackNumber,
  });
}
