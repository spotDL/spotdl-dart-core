part of '../common.dart';

/// Abstract base for all search results.
abstract class LazyResult {
  /// Artist(s) of the song.
  Stream<String> artists();

  /// Whether the song has any artists.
  Future<bool> hasArtists() async => !await artists().isEmpty;

  /// Title of the song.
  Future<String> title();

  /// Album of the song.
  Future<String> album();

  /// Whether the song has an album.
  Future<bool> hasAlbum() async => (await album()).isNotEmpty;

  /// Duration of the song in seconds.
  Future<int> sDuration();

  /// Whether the song has a duration.
  Future<bool> hasDuration() async => await sDuration() > 0;

  /// URL of the song from the given source.
  Future<String> srcUrl();

  /// URL to a downloadable stream from the given source.
  Future<String> dlUrl();

  /// Whether the song has a download URL.
  Future<bool> hasDlUrl() async => (await dlUrl()).isNotEmpty;

  /// URL to the album art.
  Future<String> artUrl();

  /// Whether the song has an album art.
  Future<bool> hasArtUrl() async => (await artUrl()).isNotEmpty;

  /// [Source] of the song.
  Future<Source> source();

  /// Convert [LazyResult] into [Result].
  Future<Result> toResult();
}
