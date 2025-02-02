part of '../spotify.dart';

/// Search & Utility functions that operate on a per-track basis.
extension TrackSearch on SpotifyEngine {
  /// Searches Spotify with the given query.
  Future<List<SpotifyResult>> searchForTrack(String query, [int itemCount = 5]) async {
    var resultPages = await _spotifyEngine.search.get(query, types: [SearchType.track]).first(itemCount);

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
              url: 'https://open.spotify.com/track/${track.uri!.split(':').last}',
              source: Src.spotify,
            ),
          );
        }
      }
    }

    return results;
  }

  /// Find a track from a Spotify URL / URI.
  ///
  /// ### Note
  /// - URL needn't be *cleaned* before passing it to this function.
  ///
  /// - Read comments on [searchForTrack] for relevant details.
  Future<SpotifyResult> findTrackFromUrl(String url) async {
    var track = await _spotifyEngine.tracks.get(url.split('/').last);

    return SpotifyResult(
      artists: track.artists!.map((artist) => artist.name!).toList(),
      title: track.name!,
      album: track.album!.name!,
      sDuration: track.durationMs! ~/ 1000,
      url: 'https://open.spotify.com/track/${track.uri!.split(':').last}',
      source: Src.spotify,
    );
  }
}
