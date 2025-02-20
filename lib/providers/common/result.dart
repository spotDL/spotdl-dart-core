part of '../common.dart';

/// Abstract base for all search results.
abstract class Result {
  /// Artist(s) of the song.
  List<String> get artists;

  /// Whether the song has any artists.
  bool get hasArtists => artists.isNotEmpty;

  /// Title of the song.
  String get title;

  /// Album of the song.
  String get album;

  /// Whether the song has an album.
  bool get hasAlbum => album.isNotEmpty;

  /// Duration of the song in seconds.
  int get sDuration;

  /// Whether the song has a duration.
  bool get hasDuration => sDuration > 0;

  /// URL of the song from the given source.
  String get srcUrl;

  /// URL to a downloadable stream from the given source.
  String get dlUrl;

  /// Whether the song has a download URL.
  bool get hasDlUrl => dlUrl.isNotEmpty;

  /// URL to the album art.
  String get artUrl;

  /// Whether the song has an album art.
  bool get hasArtUrl => artUrl.isNotEmpty;

  /// [Source] of the song.
  Source get source;

  @override
  String toString() {
    return '\n$title by ${artists.join(', ')} from "$album", ${sDuration}s\n\t$srcUrl\n\t$source ($dlUrl)\n';
  }
}
