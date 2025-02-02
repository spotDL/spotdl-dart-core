part of '../spotify.dart';

/// Search & Utility functions for searching Spotify.
class SpotifyEngine {
  late final SpotifyApi _spotifyEngine;

  /// Creates a new [SpotifyEngine].
  SpotifyEngine() {
    var credentials = SpotifyApiCredentials(
      apiKeys[Src.spotify]![Part.id],
      apiKeys[Src.spotify]![Part.se],
    );

    _spotifyEngine = SpotifyApi(credentials);
  }
}
