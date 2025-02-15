part of '../youtube.dart';

/// Search & Utility functions for YouTube.
class YoutubeEngine extends SearchEngine {
  @override
  final source = Source.youtube;

  late final YoutubeExplode _youtubeEngine;

  /// Creates a new [YoutubeEngine].
  YoutubeEngine() {
    _youtubeEngine = YoutubeExplode();
  }

  /// Searches YouTube for the given query.
  @override
  Future<List<YouTubeResult>> searchForTrack(
    String query, [
    itemCount = 5,
  ]) async {
    var searchResults = await _youtubeEngine.search.search(query);

    var results = <YouTubeResult>[];

    while (results.length < itemCount) {
      var mainArtist = searchResults.first.author.split('- Topic').first;

      // We extract the album name from the description if it starts with 'Provided to YouTube by '.
      //
      // NOTE: auto-generated youtube description goes like this:
      // -------------------------------------------------------------------------------------------
      // Example #01
      // -------------------------------------------------------------------------------------------
      //
      // Provided to YouTube by DistroKid                                       (Provider)
      //
      // Ira · Ivory Rasmus                                                     (Title) · (Artist)
      //
      // Ira                                                                    (Album)
      //
      // ℗ And Friends                                                          (Label)
      //
      // -------------------------------------------------------------------------------------------
      // Example #02
      // -------------------------------------------------------------------------------------------
      //
      // Provided to YouTube by Universal Music Group                           (Provider)
      //
      // Abracadabra · Lady Gaga                                                (Title) · (Artist)
      //
      // Abracadabra                                                            (Album)
      //
      // ℗ 2024 Interscope Records                                              (Label)
      //
      // -------------------------------------------------------------------------------------------
      //
      // We're using a convoluted split because the scraped description doesn't always come with
      // "\n\n" even if youtube has the newlines in it's rendering.
      String? album;

      if (searchResults.first.description.startsWith('Provided to YouTube by ')) {
        try {
          album = searchResults.first.description.split(mainArtist)[1].split('℗').first.trim();
        } catch (_) {
          album = null;
        }
      }

      // Extract highest bitrate audio stream URL.
      var streamManifest = await _youtubeEngine.videos.streams.getManifest(searchResults.first.id);
      var dlUrl = streamManifest.audioOnly.withHighestBitrate().url.toString();

      // Add the search result to the list.
      results.add(
        YouTubeResult(
          artists: [mainArtist],
          title: searchResults.first.title,
          album: album,
          sDuration: searchResults.first.duration!.inSeconds,
          srcUrl: searchResults.first.url,
          dlUrl: dlUrl,
          source: Source.youtube,
        ),
      );

      // Remove the first element from the search results.
      var _ = searchResults.removeAt(0);

      // If the search results are empty, fetch the next page.
      if (searchResults.isEmpty) {
        var nextResultSet = await searchResults.nextPage();

        if (nextResultSet == null) {
          break;
        } else {
          searchResults = nextResultSet;
        }
      }
    }

    return results;
  }

  @override

  /// Superior search function for YouTube.
  ///
  /// ### Note
  /// - Minimal effort is put into this function. Prefer using [YoutubeMusicEngine].
  Future<List<YouTubeResult>> searchForTrackFromResult(
    Result result, [
    int itemCount = 5,
    int durationDelta = 15,
  ]) async {
    var searchQuery = await constructSearchQuery(result);
    var results = await searchForTrack(searchQuery, itemCount);

    var filteredResults = <YouTubeResult>[];

    for (var ytResult in results) {
      if ((ytResult.sDuration - result.sDuration).abs() <= durationDelta) {
        filteredResults.add(ytResult);
      }
    }

    return filteredResults;
  }
}
