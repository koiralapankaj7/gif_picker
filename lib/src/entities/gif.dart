///
abstract class Gif {
  ///
  Gif({required this.id, required this.url});

  /// Gif id
  String id;

  /// Gif URL
  String url;
}

///
abstract class GifCategory {
  ///
  GifCategory({required this.id, required this.name});

  /// Gif category id
  String id;

  /// Gif category name
  String name;
}
