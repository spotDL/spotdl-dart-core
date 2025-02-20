part of '../youtube_music.dart';

/// Search engine for YouTube Music.
class YoutubeMusicEngine extends SearchEngine {
  /// The underlying [YTMusic] instance.
  late final YTMusic _ytMusicEngine;

  late final YoutubeExplode _ytExplode = YoutubeExplode();

  @override
  Source get source => Source.youtubeMusic;

  /// Creates a new [YoutubeMusicEngine].
  YoutubeMusicEngine._(this._ytMusicEngine);

  /// Creates a new [YoutubeMusicEngine].
  static Future<YoutubeMusicEngine> initialize() async {
    final ytmusic = YTMusic();
    var _ = await ytmusic.initialize();

    return YoutubeMusicEngine._(ytmusic);
  }

  @override
  Future<String> constructSearchQuery(Result result) async {
    return '${result.title} by ${result.artists.join(', ')} from "${result.album}"';
  }

  @override
  Future<List<YoutubeMusicResult>> searchForTrack(String query, [int itemCount = 5]) async {
    var results = await _ytMusicEngine.searchSongs(query);

    var returnList = <YoutubeMusicResult>[];

    for (var result in results) {
      var dataManifest = await _ytExplode.videos.streamsClient.getManifest(result.videoId);
      var dlUrl = dataManifest.audioOnly.withHighestBitrate().url.toString();

      var highestResThumbnail =
          result.thumbnails.reduce((a, b) => a.width * a.height > b.width * b.height ? a : b);

      returnList.add(
        YoutubeMusicResult(
          title: result.name,
          artists: [result.artist.name],
          album: result.album?.name,
          srcUrl: 'https://music.youtube.com/watch?v=${result.videoId}',
          dlUrl: dlUrl,
          sDuration: result.duration!,
          source: Source.youtubeMusic,
          artUrl: highestResThumbnail.url,
        ),
      );
    }

    return returnList;
  }

  @override
  Future<List<YoutubeMusicResult>> searchForTrackFromResult(
    Result result, [
    int itemCount = 5,
    int durationDelta = 15,
    bool albumMatchRequired = true,
  ]) async {
    var results = <YoutubeMusicResult>[];

    if (result.album != null) {
      var albumResults = await _ytMusicEngine.searchAlbums(result.album!);

      AlbumDetailed? matchingAlbumResult;

      for (var album in albumResults) {
        if (album.name == result.album) {
          matchingAlbumResult = album;
          break;
        }
      }

      if (matchingAlbumResult != null) {
        var albumSongs =
            await _ytExplode.playlists.getVideos(matchingAlbumResult.playlistId).toList();

        for (var song in albumSongs) {
          var dataManifest = await _ytExplode.videos.streamsClient.getManifest(song.id);
          var dlUrl = dataManifest.audioOnly.withHighestBitrate().url.toString();

          // Add the search result to the list.
          results.add(
            YoutubeMusicResult(
              artists: [song.author.split(' - Topic').first],
              title: song.title,
              album: matchingAlbumResult.name,
              sDuration: song.duration!.inSeconds,
              srcUrl: song.url,
              dlUrl: dlUrl,
              source: Source.youtube,
              artUrl: song.thumbnails.highResUrl,
            ),
          );
        }
      }
    }

    if (results.isEmpty) {
      var searchQuery = await constructSearchQuery(result);
      results = await searchForTrack(searchQuery, itemCount);
    }

    var filteredResults = <YoutubeMusicResult>[];

    for (var ytmResult in results) {
      // Filter out songs with different names.
      if (ytmResult.title != result.title) {
        continue;
      }

      // Filter out results with more than 15s variation in duration.
      if ((ytmResult.sDuration - result.sDuration).abs() > durationDelta) {
        continue;
      }

      // If the main artist in not common, filter out.
      if (!result.artists.any((artist) => ytmResult.artists.first.contains(artist))) {
        continue;
      }

      // If album match is required, filter out results with different album.
      if (albumMatchRequired && (ytmResult.album == null || ytmResult.album != result.album)) {
        continue;
      }

      filteredResults.add(ytmResult);
    }

    return filteredResults;
  }
}
