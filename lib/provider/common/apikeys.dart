part of '../common.dart';

/// Parts of the API key.
// ignore: prefer-match-file-name, apiKeys is a more descriptive file name.
enum Part {
  /// API id / token.
  id,

  /// API secret.
  se
}

/// API keys for all APIs in use.
const apiKeys = <Src, Map<Part, String>>{
  Src.spotify: {
    Part.id: '5f573c9620494bae87890c0f08a60293',
    Part.se: '212476d9b0f3472eaa762d90b19b0ba8',
  },
};
