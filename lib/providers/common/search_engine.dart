part of '../common.dart';

/// Abstract base class for all search engines.
abstract interface class SearchEngine {
  /// The provider source this engine is for.
  Source get source;

  /// Searches for tracks.
  Stream<LazyResult> searchForTrack(String query, [int itemCount = 5]);

  /// Searches for tracks from a [LazyResult]. Usually more accurate than [searchForTrack].
  Stream<LazyResult> searchForTrackFromResult(LazyResult result, [int itemCount = 5]);

  /// Constructs a search query from any [LazyResult] for ideal response from this [Source].
  Future<String> constructSearchQuery(LazyResult result);
}
