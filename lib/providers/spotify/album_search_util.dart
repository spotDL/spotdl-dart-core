part of '../spotify.dart';

/// Extension on [SpotifyEngine] to search for albums.
extension AlbumSearchUtil on SpotifyEngine {
  /// Search for albums on Spotify.
  Future<List<Album>> searchForAlbum(String query, [int itemCount = 5]) async {
    var resultPages =
        await _spotifyEngine.search.get(query, types: [SearchType.album]).first(itemCount);

    var results = <Album>[];

    for (var page in resultPages) {
      if (page.items != null) {
        // `page.items` is apparently a `MappedListIterable`, whatever that is,
        // so I'd rathe typecast the `item` instead.
        for (var item in page.items!) {
          var album = item as AlbumSimple;

          results.add(
            Album(
              name: album.name!,
              artist: album.artists?.first.name ?? '',
              albumUrl: 'https://open.spotify.com/album/${album.id!}',
              artUrl: album.images?.first.url ?? '',
            ),
          );
        }
      }
    }

    return results;
  }

  /// Get album from a Spotify Album URL / URI.
  Future<Album> getAlbumFromAlbumUrl(String url) async {
    var album = await _spotifyEngine.albums.get(SpotifyEngine.extractId(url));

    return Album(
      name: album.name!,
      artist: album.artists?.first.name ?? '',
      albumUrl: 'https://open.spotify.com/album/${album.id!}',
      artUrl: album.images?.first.url ?? '',
    );
  }
}

/// Represents an album.
class Album {
  /// The name of the album.
  final String name;

  /// The artist of the album.
  final String artist;

  /// The URL of the album.
  final String albumUrl;

  /// The URL of the album art.
  final String artUrl;

  /// Weave the album has artists.
  bool get hasArtist => artist.isNotEmpty;

  /// Whether the album has an album art.
  bool get hasArtUrl => artUrl.isNotEmpty;

  /// Creates a new [Album].
  Album({
    required this.name,
    required this.artist,
    required this.albumUrl,
    required this.artUrl,
  });

  @override
  String toString() => 'Album: $name by $artist\n\turl: $albumUrl\n\tart: $artUrl';
}
