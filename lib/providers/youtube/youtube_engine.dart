part of '../youtube.dart';

/// Search & Utility functions for YouTube.
class YoutubeEngine implements SearchEngine {
  @override
  final source = Source.youtube;

  late final YoutubeExplode _youtubeEngine;

  /// Creates a new [YoutubeEngine].
  YoutubeEngine() {
    _youtubeEngine = YoutubeExplode();
  }

  /// Searches YouTube for the given query.
  @override
  Future<List<LazyYouTubeResult>> searchForTrack(
    String query, [
    itemCount = 7,
  ]) async {
    var searchResults = await _youtubeEngine.search.search(query);

    var results = <LazyYouTubeResult>[];

    // We use this to track the number of results we've processed proactively
    // as result processing is kinda slow ~1s per result.
    var resultCount = 0;
    var exitLock = Completer<void>.sync();

    while (resultCount < itemCount) {
      resultCount++;
      var cResult = searchResults.removeAt(0);

      var mainArtist = cResult.author.split('- Topic').first;

      // We extract the album name from the description if it starts with 'Provided to YouTube by '.
      // NOTE: auto-generated youtube description goes like this:

      // -------------------------------------------------------------------------------------------
      // Example #01
      // -------------------------------------------------------------------------------------------
      //
      // Provided to YouTube by DistroKid                                       (Provider)
      // Ira · Ivory Rasmus                                                     (Title) · (Artist)
      // Ira                                                                    (Album)
      // ℗ And Friends                                                          (Label)

      // -------------------------------------------------------------------------------------------
      // Example #02
      // -------------------------------------------------------------------------------------------
      // Provided to YouTube by Universal Music Group                           (Provider)
      // Abracadabra · Lady Gaga                                                (Title) · (Artist)
      // Abracadabra                                                            (Album)
      // ℗ 2024 Interscope Records                                              (Label)
      //
      // -------------------------------------------------------------------------------------------

      // We're using a convoluted split because the scraped description doesn't always come with
      // "\n\n" even if youtube has the newlines in it's rendering.
      String? album;

      if (cResult.description.startsWith('Provided to YouTube by ')) {
        try {
          album = cResult.description.split(mainArtist)[1].split('℗').first.trim();
        } catch (_) {
          album = null;
        }
      }

      // Add the search result to the list.
      results.add(
        LazyYouTubeResult(
            artists: () async => [mainArtist],
            title: () async => cResult.title,
            album: () async => album ?? '',
            sDuration: () async => cResult.duration?.inSeconds ?? 0,
            srcUrl: () async => cResult.url,
            source: () async => Source.youtube,
            dlUrl: () async => _youtubeEngine.videos.streams.getManifest(cResult.id).then(
                  (streamManifest) {
                    return streamManifest.audioOnly.withHighestBitrate().url.toString();
                  },
                ),
            artUrl: () async => ''),
      );

      if (results.length >= itemCount) {
        exitLock.complete();
      }

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

    await exitLock.future;

    return results;
  }

  @override

  /// Superior search function for YouTube.
  ///
  /// ### Note
  /// - Minimal effort is put into this function. Prefer using [YoutubeMusicEngine].
  Future<List<LazyYouTubeResult>> searchForTrackFromResult(
    Result result, [
    int itemCount = 8,
    int durationDelta = 15,
  ]) async {
    var searchQuery = await constructSearchQuery(result);
    var results = await searchForTrack(searchQuery, itemCount);

    var filteredResults = <LazyYouTubeResult>[];

    for (var ytResult in results) {
      if (((await ytResult.sDuration()) - result.sDuration).abs() <= durationDelta) {
        filteredResults.add(ytResult);
      }
    }

    return filteredResults;
  }

  @override
  Future<String> constructSearchQuery(Result result) async {
    return '${result.title} by ${result.artists.join(', ')} from "${result.album}"';
  }
}
