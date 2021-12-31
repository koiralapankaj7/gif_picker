import 'package:gif_picker/gif_picker.dart';

/// Tenor gif object
class TenorGif extends Gif {
  ///
  TenorGif({
    required String id,
    required String url,
    this.title = '',
    this.contentDescription = '',
    this.contentRating = '',
    this.h1Title = '',
    this.media = const [],
    this.bgColor = '',
    this.created = 0.0,
    this.itemurl = '',
    this.tags = const [],
    this.flags = const [],
    this.shares = 0,
    this.hasaudio = false,
    this.hascaption = false,
    this.sourceId = '',
    this.composite,
  }) : super(id: id, url: url);

  /// The title of the post
  final String title;

  /// Description of the content
  final String contentDescription;

  /// Rating of the content
  final String contentRating;

  /// Title of the content as a header
  final String h1Title;

  /// An array of [GifMedia]
  final List<GifMedia> media;

  /// Background color of the content
  final String bgColor;

  /// A unix timestamp representing when this post was created.
  final double created;

  /// The full URL to view the post on tenor.com
  final String itemurl;

  /// An array of tags for the post
  final List<String> tags;

  /// An array of flags for the post
  List<String> flags;

  /// Share counts for the post
  final int shares;

  /// true if this post contains audio
  /// (only video formats support audio, the gif image file format can not
  /// contain audio information).
  final bool hasaudio;

  /// true if this post contains captions
  final bool hascaption;

  /// Source id of the post
  final String sourceId;

  /// TODO(koiralapankaj007): Update once datatype is known
  final Object? composite;
}

///
class GifMedia {
  ///
  GifMedia({
    required this.gif,
    required this.mediumgif,
    required this.tinygif,
    required this.nanogif,
    required this.mp4,
    required this.loopedmp4,
    required this.tinymp4,
    required this.nanomp4,
    required this.webm,
    required this.tinywebm,
    required this.nanowebm,
  });

  /// `Resolution and size`: High quality GIF format, largest file size
  ///  available
  ///
  /// `Dimensions`: Original upload dimensions (no limits)
  ///
  /// `Usage Notes`: Use this size for GIF shares on desktop
  ///
  final WebmGif gif;

  /// `Resolution and size`: small reduction in size of the GIF format
  ///
  /// `Dimensions`: Original upload dimensions (no limits) but much higher
  ///  compression rate
  ///
  /// `Usage Notes`: Use this size for GIF previews on desktop
  ///
  final WebmGif mediumgif;

  /// `Resolution and size`: reduced size of the GIF format
  ///
  /// `Dimensions`: Up to 220 pixels wide, Height scaled with aspect ratio
  ///  reserved
  ///
  /// `Usage Notes`: Use this size for GIF previews and shares on mobile
  ///
  final WebmGif tinygif;

  /// `Resolution and size`: smallest size of the GIF format
  ///
  /// `Dimensions`: Up to 90 pixels tall, Width scaled with aspect ratio
  ///  preserved
  ///
  /// `Usage Notes`: Use this size for GIF previews on mobile
  ///
  final WebmGif nanogif;

  /// `Resolution and size`: highest quality video format, largest of the video
  ///  formats, but smaller than GIF
  ///
  /// `Dimensions`: Similar to gif, but padded to fit video container
  ///  specifications (usually 8-pixel increments)
  ///
  /// `Usage Notes`: Use this size for MP4 previews and shares on desktop
  ///
  final Mp4Gif mp4;

  /// `Resolution and size`: highest quality video format, larger in size than
  ///  mp4
  ///
  /// `Dimensions`: Same as mp4
  ///
  /// `Usage Notes`: Use this size for mp4 shares if you want the video clip to
  ///  run a few times rather than only once
  ///
  final Mp4Gif loopedmp4;

  /// `Resolution and size`: reduced size of the mp4 format
  ///
  /// `Dimensions`: Variable width and height, with maximum bounding box of
  ///  320x320
  ///
  /// `Usage Notes`: Use this size for mp4 previews and shares on mobile
  ///
  final Mp4Gif tinymp4;

  /// `Resolution and size`: smallest size of the mp4 format
  ///
  /// `Dimensions`: Variable width and height, with maximum bounding box of
  /// 150x150
  ///
  /// `Usage Notes`: Use this size for webm previews and shares on desktop
  ///
  final Mp4Gif nanomp4;

  /// `Resolution and size`: Lower quality video format, smaller in size than
  ///  MP4
  ///
  /// `Dimensions`: Same as mp4
  ///
  /// `Usage Notes`: Use this size for webm previews and shares on desktop
  ///
  final WebmGif webm;

  /// `Resolution and size`: reduced size of the webm format
  ///
  /// `Dimensions`: Same as tinymp4
  ///
  /// `Usage Notes`: Use this size for GIF shares on mobile
  ///
  final WebmGif tinywebm;

  /// `Resolution and size`: smallest size of the webm format
  ///
  /// `Dimensions`: Same as nanomp4
  ///
  /// `Usage Notes`: Use this size for GIF previews on mobile
  ///
  final WebmGif nanowebm;
}

///
class WebmGif {
  ///
  WebmGif({
    this.preview = '',
    this.url = '',
    this.dims = const [0, 0],
    this.size = 0,
  });

  /// A url to a preview image of the media source
  final String preview;

  /// A url to the media source
  final String url;

  /// width and height in pixels
  final List<int> dims;

  /// size of file in bytes
  final int size;
}

///
class Mp4Gif {
  ///
  Mp4Gif({
    this.preview = '',
    this.url = '',
    this.dims = const [0, 0],
    this.size = 0,
    this.duration = 0,
  });

  /// A url to a preview image of the media source
  final String preview;

  /// A url to the media source
  final String url;

  /// width and height in pixels
  final List<int> dims;

  /// size of file in bytes
  final int size;

  /// Duration of the media source in seconds
  final double duration;
}

/// Tenor gif category
class TenorGifCategory extends GifCategory {
  ///
  TenorGifCategory({required String id, required String name})
      : super(id: id, name: name);
}
