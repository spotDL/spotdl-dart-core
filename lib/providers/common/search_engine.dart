part of '../common.dart';

/// Abstract base class for all search engines.
abstract class SearchEngine {
  /// The provider source this engine is for.
  Source get source;

  /// Searches for tracks.
  Future<List<Result>> searchForTrack(String query, [int itemCount = 5]);

  /// Searches for tracks from a [Result]. Usually more accurate than [searchForTrack].
  Future<List<Result>> searchForTrackFromResult(Result result, [int itemCount = 5]);

  /// Constructs a search query from any [Result] for ideal response from this [Source].
  Future<String> constructSearchQuery(Result result) async {
    return '${result.title} by ${result.artists.join(', ')} from "${result.album ?? ''}"';
  }
}
