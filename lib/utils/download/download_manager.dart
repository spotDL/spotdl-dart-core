part of '../download.dart';

/// Manages multiple sub-processes for distributed downloads.
class DownloadManager {
  /// Underlying [DownloadProcess] instances.
  final List<DownloadProcess> _downloadProcess = [];

  /// Number of [DownloadProcess] instances.
  final int _processCount;

  /// Index of [DownloadProcess] being given the next download request.
  var _cProcess = 0;

  /// Create a [DownloadManager] instance.
  DownloadManager._(this._processCount);

  /// Initialize the [DownloadManager] with a given number of sub-processes.
  static Future<DownloadManager> initialize(int processCount) async {
    final manager = DownloadManager._(processCount);

    for (var i = 0; i < processCount; i++) {
      final downloader = await DownloadProcess.initialize();
      manager._downloadProcess.add(downloader);
    }

    return manager;
  }

  /// Add a download request to the download queue.
  ///
  /// ### Returns
  /// - A [Completer] that completes when the download is done.
  Future<Completer<void>> addToDownloadQueue(String url, String filePath) async {
    var completionLock = await _downloadProcess[_cProcess].addToDownloadQueue(url, filePath);
    _cProcess = (_cProcess + 1) % _processCount;

    return completionLock;
  }

  /// Shuts down all [DownloadManager] and all sub-processes.
  void shutdown() {
    for (var downloadProcess in _downloadProcess) {
      downloadProcess.shutdown();
    }
  }
}
