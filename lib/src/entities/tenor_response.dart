import 'package:gif_picker/gif_picker.dart';

/// Response from the [GiphyService]
class TenorResponse {
  ///
  TenorResponse({
    this.results = const [],
    this.next = '',
  });

  /// An array of [TenorGif] containing the most relevant GIFs for the
  /// requested search term - Sorted by relevancy Rank
  final List<TenorGif> results;

  /// A position identifier to use with the next API query to retrieve
  /// the next set of results, or 0 if there are no further results.
  final String next;
}

/// Tenor error
///
/// In general, known errors return an http 200 status code with attributes
/// “error” and “code”, whereas unknown errors return non-200 status codes.
class TenorError {
  ///
  TenorError({this.code, required this.error});

  /// An optional numeric code to describe the error.
  final int? code;

  /// A string message describing the error
  final String error;
}

///
enum TenorGifFormat {
  /// `Resolution and size`: High quality GIF format, largest file size
  ///  available
  ///
  /// `Dimensions`: Original upload dimensions (no limits)
  ///
  /// `Usage Notes`: Use this size for GIF shares on desktop
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none], [MediaFilter.basic]
  /// & [MediaFilter.minimal]
  gif,

  /// `Resolution and size`: small reduction in size of the GIF format
  ///
  /// `Dimensions`: Original upload dimensions (no limits) but much higher
  ///  compression rate
  ///
  /// `Usage Notes`: Use this size for GIF previews on desktop
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none]
  mediumgif,

  /// `Resolution and size`: reduced size of the GIF format
  ///
  /// `Dimensions`: Up to 220 pixels wide, Height scaled with aspect ratio
  ///  reserved
  ///
  /// `Usage Notes`: Use this size for GIF previews and shares on mobile
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none], [MediaFilter.basic]
  /// & [MediaFilter.minimal]
  tinygif,

  /// `Resolution and size`: smallest size of the GIF format
  ///
  /// `Dimensions`: Up to 90 pixels tall, Width scaled with aspect ratio
  ///  preserved
  ///
  /// `Usage Notes`: Use this size for GIF previews on mobile
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none] & [MediaFilter.basic]
  nanogif,

  /// `Resolution and size`: highest quality video format, largest of the video
  ///  formats, but smaller than GIF
  ///
  /// `Dimensions`: Similar to gif, but padded to fit video container
  ///  specifications (usually 8-pixel increments)
  ///
  /// `Usage Notes`: Use this size for MP4 previews and shares on desktop
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none], [MediaFilter.basic]
  /// & [MediaFilter.minimal]
  mp4,

  /// `Resolution and size`: highest quality video format, larger in size than
  ///  mp4
  ///
  /// `Dimensions`: Same as mp4
  ///
  /// `Usage Notes`: Use this size for mp4 shares if you want the video clip to
  ///  run a few times rather than only once
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none]
  loopedmp4,

  /// `Resolution and size`: reduced size of the mp4 format
  ///
  /// `Dimensions`: Variable width and height, with maximum bounding box of
  ///  320x320
  ///
  /// `Usage Notes`: Use this size for mp4 previews and shares on mobile
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none] & [MediaFilter.basic]
  tinymp4,

  /// `Resolution and size`: smallest size of the mp4 format
  ///
  /// `Dimensions`: Variable width and height, with maximum bounding box of
  /// 150x150
  ///
  /// `Usage Notes`: Use this size for webm previews and shares on desktop
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none] & [MediaFilter.basic]
  nanomp4,

  /// `Resolution and size`: Lower quality video format, smaller in size than
  ///  MP4
  ///
  /// `Dimensions`: Same as mp4
  ///
  /// `Usage Notes`: Use this size for webm previews and shares on desktop
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none]
  webm,

  /// `Resolution and size`: reduced size of the webm format
  ///
  /// `Dimensions`: Same as tinymp4
  ///
  /// `Usage Notes`: Use this size for GIF shares on mobile
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none]
  tinywebm,

  /// `Resolution and size`: smallest size of the webm format
  ///
  /// `Dimensions`: Same as nanomp4
  ///
  /// `Usage Notes`: Use this size for GIF previews on mobile
  ///
  /// MEDIA FILTERS SUPPORTED: [MediaFilter.none]
  nanowebm,
}

///
enum MediaFilter {
  ///
  basic,

  ///
  minimal,
}

///
enum ContentFilter {
  ///
  off,

  ///
  low,

  ///
  medium,

  ///
  high,
}

///
enum ARRange {
  all,
  wide,
  standard,
}

/// ============== GIF Format Sizes ==============
///
/// The file size for each GIF format is dependent on the `dimensions` and length
/// of the specific GIF selected. Therefore, the mean and medians provided
/// below should be considered as a general guide rather than hard values.
///
/// GIF FORMAT          MEAN(KB)          MEDIAN(KB)
/// gif	                 1,472	             956
/// mediumgif	           883	               574
/// tinygif	             215	               101
/// nanogif	             77	                 56
/// mp4	                 125	               91
/// loopedmp4	           314	               228
/// tinymp4	             98	                 81
/// nanomp4	             36	                 28
/// webm	               76	                 61
/// tinywebm	           57	                 45
/// nanowebm	           35	                 25
///
///
/// Best Practices:
/// 1. For mobile, use the nano(or tiny) sized files for previews and the tiny
///    sized files for shares
/// 2. If you’re using the GIF or MP4 formats only, add the following parameter
///    to each search call: &media_filter=basic -- doing so will reduce the API
///    response size by roughly 30%.
/// 3. If you’re using the tinygif format only, change the parameter
///    to: &media_filter=minimal -- doing so will reduce the API response size
///    by roughly 50-70%.
///
/// ============== GIF Format Sizes ==============

/// ============== RESPONSE CODES ==============
///
/// 200 or 202	ok or accepted; no error
///
/// 429	Rate limit exceeded: This is not expected on most API calls,
///     but the client should try to support graceful failure and
///     retry (allow for a 30 second timeout) if this condition is encountered.
///
/// 3xx	We generally do not expect redirect status codes to come from our API,
///     but the client should try to support this.
///
/// 404	Not found - bad resource
///
/// 5xx	Unexpected server error
///
/// ============== RESPONSE CODES ==============

extension StringX on String {
  /// Convert string to [ARRange]
  ARRange get arRange {
    switch (this) {
      case 'all':
        return ARRange.all;
      case 'wide':
        return ARRange.wide;
      case 'standard':
        return ARRange.standard;
      default:
        return ARRange.standard;
    }
  }

  /// Convert string to [ContentFilter]
  ContentFilter get contentFilter {
    switch (this) {
      case 'off':
        return ContentFilter.off;
      case 'low':
        return ContentFilter.low;
      case 'medium':
        return ContentFilter.medium;
      case 'high':
        return ContentFilter.high;
      default:
        return ContentFilter.off;
    }
  }

  /// Convert string to [MediaFilter]
  MediaFilter get mediaFilter {
    switch (this) {
      case 'basic':
        return MediaFilter.basic;
      case 'minimal':
        return MediaFilter.minimal;
      default:
        return MediaFilter.basic;
    }
  }
}
