const _publicTenorKey = '94GMV97HKTZX';

/// Handles the api key
class KeyManager {
  /// Initialize a new connection id manager
  const KeyManager({
    String? tenorKey,
  }) : _tenorKey = tenorKey ?? _publicTenorKey;

  /// The tenor api key
  final String _tenorKey;

  /// Get current key
  String get key => _tenorKey;
}

///
enum ServiceProvider {
  /// Gif from tenor
  tenor,
}
