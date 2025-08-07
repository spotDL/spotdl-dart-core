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
  Stream<LazySpotifyResult> searchForTrack(String query, [int itemCount = 5]) async* {
    var resultPages =
        await _spotifyEngine.search.get(query, types: [SearchType.track]).first(itemCount);

    var results = <LazySpotifyResult>[];

    for (var page in resultPages) {
      if (page.items != null) {
        // `page.items` is apparently a `MappedListIterable`, whatever that is,
        // so I'd rathe typecast the `item` instead.
        for (var item in page.items!) {
          var track = item as Track;

          yield LazySpotifyResult(
            artists: () async* {
              if (track.artists != null) {
                for (var artist in track.artists!) {
                  yield artist.name!;
                }
              }
            },
            title: () async => track.name ?? '',
            album: () async => track.album?.name ?? '',
            sDuration: () async => track.durationMs! ~/ 1000,
            srcUrl: () async => 'https://open.spotify.com/track/${track.uri?.split(':').last}',
            dlUrl: () async => '', // Spotify does not provide a direct download URL.
            artUrl: () async => track.album?.images?.first.url ?? '',
            diskNumber: track.discNumber ?? 0,
            trackNumber: track.trackNumber ?? 0,
          );
        }
      }
    }
  }

  @override
  Stream<LazySpotifyResult> searchForTrackFromResult(
    LazyResult result, [
    int itemCount = 5,
    int durationDelta = 15,
    double commonArtistThreshold = 0.5,
    bool albumMatchRequired = false,
  ]) async* {
    var searchQuery = await constructSearchQuery(result);
    var results = await searchForTrack(searchQuery, itemCount);

    await for (var spotifyResult in results) {
      var sDuration = await spotifyResult.sDuration();
      var rDuration = await result.sDuration();

      // Filter out results with more than durationDelta seconds difference.
      if ((sDuration - rDuration).abs() >= durationDelta) {
        continue;
      }

      // Filter out result with less than commonArtistThreshold common artists.
      var sArtists = (await spotifyResult.artists().toList()).map((artist) => artist.toLowerCase());
      var rArtists = (await result.artists().toList()).map((artist) => artist.toLowerCase());
      var cArtists = sArtists.where((sArtist) => rArtists.contains(sArtist)).length;

      if (cArtists < (rArtists.length * commonArtistThreshold).round()) {
        continue;
      }

      // Album Match depending on input parameters.
      var sAlbum = (await spotifyResult.album()).toLowerCase();
      var rAlbum = (await result.album()).toLowerCase();

      if (sAlbum != rAlbum && albumMatchRequired) {
        continue;
      }

      // Yield the result if all checks pass.
      yield spotifyResult;
    }
  }

  @override
  Future<String> constructSearchQuery(LazyResult result) async =>
      '${await result.title()} by ${(await result.artists()).join(', ')} from "${await result.album()}"';
}
