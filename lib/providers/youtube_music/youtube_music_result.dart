part of '../youtube_music.dart';

/// A search result from YouTube Music.
///
/// ### Note
/// - As YoutubeMusic can be used as a *Source of Truth*, [YoutubeMusicResult] has the following
/// extra fields:
///   - [artUrl]
class YoutubeMusicResult extends Result {
  /// Title of the track.
  @override
  final String title;

  /// Artists of the track.
  @override
  final List<String> artists;

  /// Album of the track.
  @override
  final String album;

  /// Source URL of the track.
  @override
  final String srcUrl;

  /// Download URL of the track.
  @override
  final String dlUrl;

  /// Duration of the track in seconds.
  @override
  final int sDuration;

  /// Source of the track.
  @override
  final Source source;

  /// Art URL of the track.
  final String artUrl;

  /// Creates a new [YoutubeMusicResult].
  YoutubeMusicResult({
    required this.title,
    required this.artists,
    required this.album,
    required this.srcUrl,
    required this.dlUrl,
    required this.sDuration,
    required this.source,
    required this.artUrl,
  });
}
