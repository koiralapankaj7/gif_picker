import 'package:gif_picker/gif_picker.dart';

/// Tenor gif object
class TenorGif extends Gif {
  ///
  TenorGif({required String id, required String url}) : super(id: id, url: url);
}

/// Tenor gif category
class TenorGifCategory extends GifCategory {
  ///
  TenorGifCategory({required String id, required String name})
      : super(id: id, name: name);
}
