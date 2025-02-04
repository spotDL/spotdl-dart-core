part of '../common.dart';

/// Handles serving of API tokens.
class ApiManager {
  static final _defaultTokens = <Source, Map<TokenPart, String>>{
    Source.spotify: {
      TokenPart.id: '5f573c9620494bae87890c0f08a60293',
      TokenPart.se: '212476d9b0f3472eaa762d90b19b0ba8',
    },
  };

  /// All updated API keys.
  ///
  /// ### Note
  /// - See also [Source] and [TokenPart].
  ///
  /// - If a `.apikeys` file is found in the executable directory, values from that file will be
  ///   used, else default values will be used.
  ///
  /// - The `.apikeys` file should be a JSON file with the following structure:
  ///   ```json
  ///   {
  ///     // Keys are `Src` / `Part` enum values as Strings.
  ///     "Source.spotify": {
  ///       "TokenPart.id": "your_spotify_id",
  ///       "TokenPart.se": "your_spotify_secret"
  ///     }
  ///   }
  ///   ```
  static Map<Source, Map<TokenPart, String>> get tokens {
    // Note: Platform.resolvedExecutable points to the dart executable in script form, and
    // the compiled executable after application compilation, take this into consideration while
    // writing test code during development.
    var executableDir = File(Platform.resolvedExecutable).parent.path;
    var file =
        File(executableDir + (Platform.isWindows ? '\\.apikeys' : '/.apikeys'));

    // If file exists, update _defaultTokens.
    if (file.existsSync()) {
      var tokenData = file.readAsStringSync();

      // Note: Converting to Map<String, dynamic> instead of Map<String, Map<String, String>>
      // because it keeps throwing conversion errors for some reason.
      (jsonDecode(tokenData) as Map<String, dynamic>).forEach(
        (key, value) {
          // String -> Src conversion for easy updating later.
          var srcToken =
              Source.values.firstWhere((token) => token.toString() == key);

          (value as Map<String, dynamic>).forEach(
            (key, value) {
              // String -> Part conversion for easy updating later.
              var partToken = TokenPart.values
                  .firstWhere((token) => token.toString() == key);

              _defaultTokens[srcToken]![partToken] = value as String;
            },
          );
        },
      );
    }

    return _defaultTokens;
  }
}

/// Parts of the API Token.
// ignore: prefer-match-file-name, apiKeys is a more descriptive file name.
enum TokenPart {
  /// Token id.
  id,

  /// Token secret.
  se
}
