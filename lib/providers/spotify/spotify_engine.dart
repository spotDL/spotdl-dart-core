part of '../spotify.dart';

/// Search & Utility functions for searching Spotify.
class SpotifyEngine implements SearchEngine {
  @override
  final source = Source.spotify;

  late final SpotifyApi _spotifyEngine;

  /// Creates a new [SpotifyEngine].
  SpotifyEngine() {
    var credentials = SpotifyApiCredentials(
      ApiManager.tokens[Source.spotify]![TokenPart.id],
      ApiManager.tokens[Source.spotify]![TokenPart.se],
    );

    _spotifyEngine = SpotifyApi(credentials);
  }

  /// Extract the URI from a Spotify URL.
  static String extractId(String url) {
    return url.split('/').last.split('?si=').first;
  }

  /// Searches for tracks on Spotify.
  // NOTE: This should be in the [TrackSearch] extension, but is implemented here to keep in line
  // with the [SrcEngine] interface.
  @override
  Future<List<SpotifyResult>> searchForTrack(String query, [int itemCount = 5]) async {
    var resultPages =
        await _spotifyEngine.search.get(query, types: [SearchType.track]).first(itemCount);

    var results = <SpotifyResult>[];

    for (var page in resultPages) {
      if (page.items != null) {
        // `page.items` is apparently a `MappedListIterable`, whatever that is,
        // so I'd rathe typecast the `item` instead.
        for (var item in page.items!) {
          var track = item as Track;

          // for some reason, all fields are nullable, e.g. track.artist is not of type `Artist`,
          // but `Artist?`. I assume that it will always be non-null, so I'm using `!` to access.
          results.add(
            SpotifyResult(
              artists: track.artists!.map((artist) => artist.name!).toList(),
              title: track.name!,
              album: track.album!.name!,
              sDuration: track.durationMs! ~/ 1000,
              srcUrl: 'https://open.spotify.com/track/${track.uri!.split(':').last}',
              artUrl: track.album!.images!.first.url!,
              source: Source.spotify,
              diskNumber: track.discNumber!,
              trackNumber: track.trackNumber!,
            ),
          );
        }
      }
    }

    return results;
  }

  @override
  Future<List<SpotifyResult>> searchForTrackFromResult(
    Result result, [
    int itemCount = 5,
    int durationDelta = 15,
    double commonArtistThreshold = 0.5,
    bool albumMatchRequired = false,
  ]) async {
    var searchQuery = await constructSearchQuery(result);
    var results = await searchForTrack(searchQuery, itemCount);

    var filteredResults = <SpotifyResult>[];

    for (var spotifyResult in results) {
      // Filter out results with more than durationDelta seconds difference.
      if ((spotifyResult.sDuration - result.sDuration).abs() >= durationDelta) {
        continue;
      }

      // Filter out results with less than commonArtistThreshold common artists.
      var resultArtists = result.artists.map((artist) => artist.toLowerCase());
      var spotifyArtists = spotifyResult.artists.map((sArtist) => sArtist.toLowerCase());
      var commonArtists = resultArtists.where((artist) => spotifyArtists.contains(artist));

      if (commonArtists.length < (resultArtists.length * commonArtistThreshold).round()) {
        continue;
      }

      // Album Match depending on input parameters.
      if (spotifyResult.album.toLowerCase() != result.album!.toLowerCase() && albumMatchRequired) {
        continue;
      }

      // If a result passes all filters, add to filtered results.
      filteredResults.add(spotifyResult);
    }

    return filteredResults;
  }

  @override
  Future<String> constructSearchQuery(Result result) async {
    return '${result.title} by ${result.artists.join(', ')} from "${result.album ?? ''}"';
  }
}
