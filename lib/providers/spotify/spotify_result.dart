part of '../spotify.dart';

/// A search result (Track) from Spotify.
///
/// ### Note
///
/// - As Spotify is the *Source of Truth*, [SpotifyResult] has the following extra fields:
///   - [diskNumber]
///   - [trackNumber]
///   - [artUrl]
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
  final String srcUrl;

  @override
  final String dlUrl = '';

  /// The URL to the album art.
  @override
  final String artUrl;

  @override
  final Source source;

  /// The disk number of the track. `1` unless from an multi-disk album.
  final int diskNumber;

  /// The track number of the album disk.
  final int trackNumber;

  /// Track has disk number.
  bool get hasDiskNumber => diskNumber > 1;

  /// Track has track number.
  bool get hasTrackNumber => trackNumber > 1;

  /// Creates a new [SpotifyResult].
  SpotifyResult({
    required this.artists,
    required this.title,
    required this.album,
    required this.sDuration,
    required this.srcUrl,
    required this.artUrl,
    required this.source,
    required this.diskNumber,
    required this.trackNumber,
  });
}
