part of '../spotify.dart';

/// Search & Utility functions for searching Spotify.
class SpotifyEngine extends SrcEngine {
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

  @override
  Future<String> constructSearchQuery(Result result) async {
    return '${result.title}, ${result.album ?? ''},${result.artists.join(', ')}';
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
}
