part of '../common.dart';

/// Abstract base class for all search engines.
abstract class SrcEngine {
  /// The provider source this engine is for.
  Source get source;

  /// Searches for tracks.
  Future<List<Result>> searchForTrack(String query, [int itemCount = 5]);

  /// Constructs a search query from any [Result] for ideal response from this [Source].
  Future<String> constructSearchQuery(Result result);
}
