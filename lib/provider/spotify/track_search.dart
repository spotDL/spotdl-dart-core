part of '../spotify.dart';

/// Search & Utility functions to find Tracks.
extension TrackSearch on SpotifyEngine {
  /// Find a track from a Spotify Track URL / URI.
  ///
  /// ### Note
  /// - URL needn't be *cleaned* before passing it to this function.
  ///
  Future<SpotifyResult> getTrackFromTrackUrl(String url) async {
    var track = await _spotifyEngine.tracks.get(SpotifyEngine.extractId(url));

    return SpotifyResult(
      artists: track.artists!.map((artist) => artist.name!).toList(),
      title: track.name!,
      album: track.album!.name!,
      sDuration: track.durationMs! ~/ 1000,
      srcUrl: 'https://open.spotify.com/track/${track.uri!.split(':').last}',
      source: Source.spotify,
      diskNumber: track.discNumber!,
      trackNumber: track.trackNumber!,
    );
  }

  /// Get the tracks from a Spotify Album URL / URI.
  Future<List<SpotifyResult>> getTracksFromAlbumUrl(String url) async {
    var results = <SpotifyResult>[];

    var tracks = await _spotifyEngine.albums.tracks(SpotifyEngine.extractId(url)).all();
    var album = await _spotifyEngine.albums.get(SpotifyEngine.extractId(url));

    for (var track in tracks) {
      results.add(
        SpotifyResult(
          artists: track.artists!.map((artist) => artist.name!).toList(),
          title: track.name!,
          album: album.name!,
          sDuration: track.durationMs! ~/ 1000,
          srcUrl: 'https://open.spotify.com/track/${track.uri!.split(':').last}',
          source: Source.spotify,
          diskNumber: track.discNumber!,
          trackNumber: track.trackNumber!,
        ),
      );
    }

    return results;
  }

  /// Get the tracks from a Spotify Playlist URL / URI.
  ///
  /// ### Note
  /// - URL needn't be *cleaned* before passing it to this function.
  Future<List<SpotifyResult>> getTracksFromPlaylistUrl(String url) async {
    var results = <SpotifyResult>[];

    var tracks =
        await _spotifyEngine.playlists.getTracksByPlaylistId(SpotifyEngine.extractId(url)).all();

    for (var track in tracks) {
      results.add(
        SpotifyResult(
          artists: track.artists!.map((artist) => artist.name!).toList(),
          title: track.name!,
          album: track.album!.name!,
          sDuration: track.durationMs! ~/ 1000,
          srcUrl: 'https://open.spotify.com/track/${track.uri!.split(':').last}',
          source: Source.spotify,
          diskNumber: track.discNumber!,
          trackNumber: track.trackNumber!,
        ),
      );
    }

    return results;
  }
}
