part of '../youtube.dart';

/// A search result from YouTube.
class YouTubeResult extends Result {
  @override
  final List<String> artists;

  @override
  final String title;

  @override
  final String? album;

  @override
  final int sDuration;

  @override
  final String srcUrl;

  @override
  final String? dlUrl;

  @override
  final Source source;

  /// Creates a new [YouTubeResult].
  YouTubeResult({
    required this.artists,
    required this.title,
    required this.album,
    required this.sDuration,
    required this.srcUrl,
    required this.dlUrl,
    required this.source,
  });
}
