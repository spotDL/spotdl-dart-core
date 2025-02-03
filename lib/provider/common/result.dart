part of '../common.dart';

/// Abstract base for all search results.
abstract class Result {
  /// Artist(s) of the song.
  List<String> get artists;

  /// Title of the song.
  String get title;

  /// Album of the song.
  String get album;

  /// Duration of the song in seconds.
  int get sDuration;

  /// URL of the song.
  String get url;

  /// [TokenSrc] of the song.
  TokenSrc get source;

  @override
  String toString() {
    return '$title by ${artists.join(', ')} from "$album", ${sDuration}s\n\t$url\n\t$source';
  }
}
