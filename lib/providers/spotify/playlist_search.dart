part of '../spotify.dart';

/// Search & Utility functions to find Playlists.
extension PlaylistSearch on SpotifyEngine {
  /// Search for playlists on Spotify.
  ///
  /// ### Note
  /// - Same as results on the playlist tab, but excluding the user's own playlists. Best for
  /// Spotify-owned playlists.
  Future<List<Playlist>> searchForPlaylist(String query,
      [int itemCount = 5]) async {
    var resultPages = await _spotifyEngine.search
        .get(query, types: [SearchType.playlist]).first(itemCount);

    var results = <Playlist>[];

    for (var page in resultPages) {
      if (page.items != null) {
        // `page.items` is apparently a `MappedListIterable`, whatever that is,
        // so I'd rathe typecast the `item` instead.
        for (var item in page.items!) {
          var playlist = item as PlaylistSimple;

          results.add(
            Playlist(
              name: playlist.name!,
              user: playlist.owner!.displayName!,
              url: 'https://open.spotify.com/playlist/${playlist.id!}',
            ),
          );
        }
      }
    }

    return results;
  }

  /// Get the playlists of a user.
  ///
  /// ### Note
  /// - UserId is not the same as the user's display name on Spotify. Obtain userId from `Profile` >
  /// `Copy link to Profile` on your spotify client.
  ///
  /// - The URL needn't be *cleaned* before passing it to this function.
  Future<List<Playlist>> getUserPlaylists(String url) async {
    var userPlaylists = await _spotifyEngine.playlists
        .getUsersPlaylists(SpotifyEngine.extractId(url))
        .all();

    return userPlaylists
        .map(
          (playlist) => Playlist(
            name: playlist.name!,
            user: playlist.owner!.displayName!,
            url: 'https://open.spotify.com/playlist/${playlist.id!}',
          ),
        )
        .toList();
  }

  /// Get the playlists from a Spotify Playlist URL / URI.
  Future<Playlist> getPlaylistFromPlaylistUrl(String url) async {
    var playlist =
        await _spotifyEngine.playlists.get(SpotifyEngine.extractId(url));

    return Playlist(
      name: playlist.name!,
      user: playlist.owner!.displayName!,
      url: 'https://open.spotify.com/playlist/${playlist.id!}',
    );
  }
}

/// A playlist from Spotify.
class Playlist {
  /// The name of the playlist.
  final String name;

  /// The user who owns the playlist.
  final String user;

  /// The URL of the playlist.
  final String url;

  /// Creates a new [Playlist].
  Playlist({
    required this.name,
    required this.user,
    required this.url,
  });

  @override
  String toString() => 'Playlist "$name" by $user\n\t$url';
}
