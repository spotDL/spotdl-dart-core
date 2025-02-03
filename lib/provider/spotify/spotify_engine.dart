part of '../spotify.dart';

/// Search & Utility functions for searching Spotify.
class SpotifyEngine {
  late final SpotifyApi _spotifyEngine;

  /// Creates a new [SpotifyEngine].
  SpotifyEngine() {
    var credentials = SpotifyApiCredentials(
      ApiManager.tokens[TokenSrc.spotify]![TokenPart.id],
      ApiManager.tokens[TokenSrc.spotify]![TokenPart.se],
    );

    _spotifyEngine = SpotifyApi(credentials);
  }

  /// Extract the URI from a Spotify URL.
  static String extractId(String url) {
    return url.split('/').last.split('?si=').first;
  }
}
