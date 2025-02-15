part of '../common.dart';

/// Abstract base for all search results.
abstract class Result {
  /// Artist(s) of the song.
  List<String> get artists;

  /// Title of the song.
  String get title;

  /// Album of the song.
  ///
  /// ### Note
  /// - Nullable because most sources may not consistently provide this information.
  String? get album;

  /// Duration of the song in seconds.
  int get sDuration;

  /// URL of the song from the given source.
  String get srcUrl;

  /// URL to a downloadable stream from the given source.
  ///
  /// ### Note
  /// - Nullable because some sources can't be used to download songs.
  String? get dlUrl;

  /// [Source] of the song.
  Source get source;

  @override
  String toString() {
    return '$title by ${artists.join(', ')} from "$album", ${sDuration}s\n\t$srcUrl\n\t$source ($dlUrl)';
  }
}
