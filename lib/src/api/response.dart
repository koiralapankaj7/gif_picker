// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/foundation.dart';

///
typedef Json = Map<String, dynamic>;
const _emptyJson = <String, dynamic>{};

@immutable
class _BaseResponse {
  const _BaseResponse();
}

///
///
/// ============== RESPONSE CODES ==============
///
/// `200 or 202`	ok or accepted; no error
///
/// `429`	        Rate limit exceeded: This is not expected on most API calls,
///               but the client should try to support graceful failure and
///               retry (allow for a 30 second timeout) if this condition is encountered.
///
/// `3xx`	        We generally do not expect redirect status codes to come from our API,
///               but the client should try to support this.
///
/// `404`	        Not found - bad resource
///
/// `5xx`	        Unexpected server error
///
/// ============== RESPONSE CODES ==============
///

class TenorError extends _BaseResponse {
  ///
  const TenorError({
    required this.error,
    this.code,
    this.statusCode,
    this.moreInfo,
  });

  ///
  factory TenorError.fromJson(Json map) {
    return TenorError(
      error: map['error'] as String? ?? 'Unknown error',
      code: map['code'] as int?,
      statusCode: map['statusCode'] as int?,
      moreInfo: map['moreInfo'] as String?,
    );
  }

  /// The message associated to the error code
  final String error;

  /// The http error code
  final int? code;

  /// The backend error code
  final int? statusCode;

  /// A detailed message about the error
  final String? moreInfo;

  ///
  TenorError copyWith({
    String? error,
    int? code,
    int? statusCode,
    String? moreInfo,
  }) {
    return TenorError(
      code: code ?? this.code,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      moreInfo: moreInfo ?? this.moreInfo,
    );
  }

  ///
  Json toJson() {
    return <String, dynamic>{
      'error': error,
      'code': code,
      'statusCode': statusCode,
      'moreInfo': moreInfo,
    };
  }

  @override
  String toString() {
    return '''
    ErrorResponse(
      error: $error, 
      code: $code, 
      statusCode: $statusCode, 
      moreInfo: $moreInfo
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorError &&
        other.error == error &&
        other.code == code &&
        other.statusCode == statusCode &&
        other.moreInfo == moreInfo;
  }

  @override
  int get hashCode {
    return error.hashCode ^
        code.hashCode ^
        statusCode.hashCode ^
        moreInfo.hashCode;
  }
}

///
@immutable
class TenorCollection {
  ///
  const TenorCollection({
    this.items = const [],
    this.next = '',
  });

  ///
  factory TenorCollection.fromJson(Json json) {
    final results = json['results'] as List<Json>? ?? const <Json>[];
    return TenorCollection(
      items: results.map((e) => TenorGif.fromJson(e)).toList(),
      next: json['next'] as String? ?? '',
    );
  }

  /// An array of [TenorGif] containing the most relevant GIFs for the
  /// requested search term - Sorted by relevancy Rank
  final List<TenorGif> items;

  /// A position identifier to use with the next API query to retrieve
  /// the next set of results, or 0 if there are no further results.
  final String next;

  ///
  TenorCollection copyWith({
    List<TenorGif>? items,
    String? next,
  }) {
    return TenorCollection(
      items: items ?? this.items,
      next: next ?? this.next,
    );
  }

  ///
  Json toJson() {
    return <String, dynamic>{
      'results': items.map((x) => x.toJson()).toList(),
      'next': next,
    };
  }

  @override
  String toString() => 'TenorSearch(items: $items, next: $next)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorCollection &&
        listEquals(other.items, items) &&
        other.next == next;
  }

  @override
  int get hashCode => items.hashCode ^ next.hashCode;
}

///
@immutable
class TenorTerms {
  ///
  const TenorTerms({
    this.locale = '',
    this.results = const [],
  });

  ///
  factory TenorTerms.fromJson(Json json) {
    return TenorTerms(
      locale: json['locale'] as String? ?? '',
      results: json['results'] as List<String>? ?? const <String>[],
    );
  }

  ///
  final String locale;

  /// An array of [TenorGif] containing the most relevant GIFs for the
  /// requested search term - Sorted by relevancy Rank
  final List<String> results;

  ///
  TenorTerms copyWith({
    String? locale,
    List<String>? results,
  }) {
    return TenorTerms(
      locale: locale ?? this.locale,
      results: results ?? this.results,
    );
  }

  ///
  Json toJson() {
    return <String, dynamic>{'locale': locale, 'results': results};
  }

  @override
  String toString() => 'TenorTerms(locale: $locale, terms: $results)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorTerms &&
        other.locale == locale &&
        listEquals(other.results, results);
  }

  @override
  int get hashCode => locale.hashCode ^ results.hashCode;
}

///
@immutable
class TenorTrending {
  ///
  const TenorTrending({
    this.locale = '',
    this.items = const [],
    this.next = '',
  });

  ///
  factory TenorTrending.fromMap(Json json) {
    final results = json['results'] as List<Json>? ?? <Json>[];
    return TenorTrending(
      locale: json['locale'] as String? ?? '',
      items: results.map((e) => TenorGif.fromJson(e)).toList(),
      next: json['next'] as String? ?? '',
    );
  }

  ///
  final String locale;

  /// An array of [TenorGif] containing the most relevant GIFs for the
  /// requested search term - Sorted by relevancy Rank
  final List<TenorGif> items;

  /// A position identifier to use with the next API query to retrieve
  /// the next set of results, or 0 if there are no further results.
  final String next;

  ///
  TenorTrending copyWith({
    String? locale,
    List<TenorGif>? items,
    String? next,
  }) {
    return TenorTrending(
      locale: locale ?? this.locale,
      items: items ?? this.items,
      next: next ?? this.next,
    );
  }

  ///
  Json toJson() {
    return <String, dynamic>{
      'locale': locale,
      'results': items.map((x) => x.toJson()).toList(),
      'next': next,
    };
  }

  @override
  String toString() =>
      'TenorTrending(locale: $locale, items: $items, next: $next)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorTrending &&
        other.locale == locale &&
        listEquals(other.items, items) &&
        other.next == next;
  }

  @override
  int get hashCode => locale.hashCode ^ items.hashCode ^ next.hashCode;
}

/// Tenor gif object
@immutable
class TenorGif {
  ///
  const TenorGif({
    required this.id,
    this.title = '',
    this.description = '',
    this.rating = '',
    this.h1Title = '',
    this.media = const [],
    this.bgColor = '',
    this.created = 0.0,
    this.itemurl = '',
    this.url = '',
    this.tags = const [],
    this.flags = const [],
    this.shares = 0,
    this.hasaudio = false,
    this.hascaption = false,
    this.sourceId = '',
    this.composite,
  });

  ///
  factory TenorGif.fromJson(Json json) {
    final medias = json['media'] as List<Json>? ?? const <Json>[];
    return TenorGif(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['content_description'] as String? ?? '',
      rating: json['content_rating'] as String? ?? '',
      h1Title: json['h1_title'] as String? ?? '',
      media: medias.map((e) => TenorMedia.fromJson(e)).toList(),
      bgColor: json['bg_color'] as String? ?? '',
      created: json['created'] as double? ?? 0.0,
      itemurl: json['itemurl'] as String? ?? '',
      url: json['url'] as String? ?? '',
      tags: List<String>.from(json['tags'] as List<String>? ?? <String>[]),
      shares: json['shares'] as int? ?? 0,
      hasaudio: json['hasaudio'] as bool? ?? false,
      hascaption: json['hascaption'] as bool? ?? false,
      sourceId: json['source_id'] as String? ?? '',
      composite: json['composite'],
    );
  }

  /// The unique identifier for this GIF
  final String id;

  /// The title of the post
  final String title;

  /// Description of the content
  final String description;

  /// Rating of the content
  final String rating;

  /// Title of the content as a header
  final String h1Title;

  /// An array of [TenorMedia]
  final List<TenorMedia> media;

  /// Background color of the content
  final String bgColor;

  /// A unix timestamp representing when this post was created.
  final double created;

  /// The full URL to view the post on tenor.com
  final String itemurl;

  /// The short URL for the GIF
  final String url;

  /// An array of tags for the post
  final List<String> tags;

  /// An array of flags for the post
  final List<String> flags;

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
  final dynamic composite;

  ///
  TenorGif copyWith({
    String? id,
    String? title,
    String? description,
    String? rating,
    String? h1Title,
    List<TenorMedia>? media,
    String? bgColor,
    double? created,
    String? itemurl,
    String? url,
    List<String>? tags,
    int? shares,
    bool? hasaudio,
    bool? hascaption,
    String? sourceId,
    Object? composite,
  }) {
    return TenorGif(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      h1Title: h1Title ?? this.h1Title,
      media: media ?? this.media,
      bgColor: bgColor ?? this.bgColor,
      created: created ?? this.created,
      itemurl: itemurl ?? this.itemurl,
      url: url ?? this.url,
      tags: tags ?? this.tags,
      shares: shares ?? this.shares,
      hasaudio: hasaudio ?? this.hasaudio,
      hascaption: hascaption ?? this.hascaption,
      sourceId: sourceId ?? this.sourceId,
      composite: composite ?? this.composite,
    );
  }

  ///
  Json toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content_description': description,
      'content_rating': rating,
      'h1_title': h1Title,
      'media': media.map((x) => x.toJson()).toList(),
      'bg_color': bgColor,
      'created': created,
      'itemurl': itemurl,
      'url': url,
      'tags': tags,
      'shares': shares,
      'hasaudio': hasaudio,
      'hascaption': hascaption,
      'source_id': sourceId,
      'composite': composite,
    };
  }

  @override
  String toString() {
    return '''
    TenorGif(
      id: $id, 
      title: $title, 
      description: $description, 
      rating: $rating, 
      h1Title: $h1Title,
      media: $media, 
      bgColor: $bgColor, 
      created: $created, 
      itemurl: $itemurl, 
      url: $url, 
      tags: $tags, 
      shares: $shares, 
      hasaudio: $hasaudio, 
      hascaption: $hascaption, 
      sourceId: $sourceId, 
      composite: $composite
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorGif &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.rating == rating &&
        other.h1Title == h1Title &&
        listEquals(other.media, media) &&
        other.bgColor == bgColor &&
        other.created == created &&
        other.itemurl == itemurl &&
        other.url == url &&
        listEquals(other.tags, tags) &&
        other.shares == shares &&
        other.hasaudio == hasaudio &&
        other.hascaption == hascaption &&
        other.sourceId == sourceId &&
        other.composite == composite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        rating.hashCode ^
        h1Title.hashCode ^
        media.hashCode ^
        bgColor.hashCode ^
        created.hashCode ^
        itemurl.hashCode ^
        url.hashCode ^
        tags.hashCode ^
        shares.hashCode ^
        hasaudio.hashCode ^
        hascaption.hashCode ^
        sourceId.hashCode ^
        composite.hashCode;
  }
}

/// ============== GIF Format Sizes ==============
///
/// The file size for each GIF format is dependent on the `dimensions` and length
/// of the specific GIF selected. Therefore, the mean and medians provided
/// below should be considered as a general guide rather than hard values.
/// ```
/// GIF FORMAT           MEAN(KB)             MEDIAN(KB)
/// gif	                1,472	             956
/// mediumgif	          883	               574
/// tinygif	            215	               101
/// nanogif	            77	                56
/// mp4	                125	               91
/// loopedmp4	          314	               228
/// tinymp4	            98	                81
/// nanomp4	            36	                28
/// webm	               76	                61
/// tinywebm	           57	                45
/// nanowebm	           35	                25
/// ```
///
/// Best Practices:
/// 1. For mobile, use the nano(or tiny) sized files for previews and the tiny
///    sized files for shares
///
/// 2. If you’re using the GIF or MP4 formats only, add the following parameter
///    to each search call: &media_filter=basic -- doing so will reduce the API
///    response size by roughly 30%.
///
/// 3. If you’re using the tinygif format only, change the parameter
///    to: &media_filter=minimal -- doing so will reduce the API response size
///    by roughly 50-70%.
///
/// ============== GIF Format Sizes ==============
@immutable
class TenorMedia {
  ///
  const TenorMedia({
    required this.gif,
    required this.mediumGif,
    required this.tinyGif,
    required this.nanoGif,
    required this.mp4,
    required this.loopedMp4,
    required this.tinyMp4,
    required this.nanoMp4,
    required this.webm,
    required this.tinyWebm,
    required this.nanoWebm,
  });

  ///
  factory TenorMedia.fromJson(Json json) {
    return TenorMedia(
      gif: TenorWebm.fromJson(json['gif'] as Json? ?? _emptyJson),
      mediumGif: TenorWebm.fromJson(json['mediumgif'] as Json? ?? _emptyJson),
      tinyGif: TenorWebm.fromJson(json['tinygif'] as Json? ?? _emptyJson),
      nanoGif: TenorWebm.fromJson(json['nanogif'] as Json? ?? _emptyJson),
      mp4: TenorMp4.fromJson(json['mp4'] as Json? ?? _emptyJson),
      loopedMp4: TenorMp4.fromJson(json['loopedmp4'] as Json? ?? _emptyJson),
      tinyMp4: TenorMp4.fromJson(json['tinymp4'] as Json? ?? _emptyJson),
      nanoMp4: TenorMp4.fromJson(json['nanomp4'] as Json? ?? _emptyJson),
      webm: TenorWebm.fromJson(json['webm'] as Json? ?? _emptyJson),
      tinyWebm: TenorWebm.fromJson(json['tinywebm'] as Json? ?? _emptyJson),
      nanoWebm: TenorWebm.fromJson(json['nanowebm'] as Json? ?? _emptyJson),
    );
  }

  /// `Resolution and size`: High quality GIF format, largest file size
  ///  available
  ///
  /// `Dimensions`: Original upload dimensions (no limits)
  ///
  /// `Usage Notes`: Use this size for GIF shares on desktop
  ///
  final TenorWebm gif;

  /// `Resolution and size`: small reduction in size of the GIF format
  ///
  /// `Dimensions`: Original upload dimensions (no limits) but much higher
  ///  compression rate
  ///
  /// `Usage Notes`: Use this size for GIF previews on desktop
  ///
  final TenorWebm mediumGif;

  /// `Resolution and size`: reduced size of the GIF format
  ///
  /// `Dimensions`: Up to 220 pixels wide, Height scaled with aspect ratio
  ///  reserved
  ///
  /// `Usage Notes`: Use this size for GIF previews and shares on mobile
  ///
  final TenorWebm tinyGif;

  /// `Resolution and size`: smallest size of the GIF format
  ///
  /// `Dimensions`: Up to 90 pixels tall, Width scaled with aspect ratio
  ///  preserved
  ///
  /// `Usage Notes`: Use this size for GIF previews on mobile
  ///
  final TenorWebm nanoGif;

  /// `Resolution and size`: highest quality video format, largest of the video
  ///  formats, but smaller than GIF
  ///
  /// `Dimensions`: Similar to gif, but padded to fit video container
  ///  specifications (usually 8-pixel increments)
  ///
  /// `Usage Notes`: Use this size for MP4 previews and shares on desktop
  ///
  final TenorMp4 mp4;

  /// `Resolution and size`: highest quality video format, larger in size than
  ///  mp4
  ///
  /// `Dimensions`: Same as mp4
  ///
  /// `Usage Notes`: Use this size for mp4 shares if you want the video clip to
  ///  run a few times rather than only once
  ///
  final TenorMp4 loopedMp4;

  /// `Resolution and size`: reduced size of the mp4 format
  ///
  /// `Dimensions`: Variable width and height, with maximum bounding box of
  ///  320x320
  ///
  /// `Usage Notes`: Use this size for mp4 previews and shares on mobile
  ///
  final TenorMp4 tinyMp4;

  /// `Resolution and size`: smallest size of the mp4 format
  ///
  /// `Dimensions`: Variable width and height, with maximum bounding box of
  /// 150x150
  ///
  /// `Usage Notes`: Use this size for webm previews and shares on desktop
  ///
  final TenorMp4 nanoMp4;

  /// `Resolution and size`: Lower quality video format, smaller in size than
  ///  MP4
  ///
  /// `Dimensions`: Same as mp4
  ///
  /// `Usage Notes`: Use this size for webm previews and shares on desktop
  ///
  final TenorWebm webm;

  /// `Resolution and size`: reduced size of the webm format
  ///
  /// `Dimensions`: Same as tinymp4
  ///
  /// `Usage Notes`: Use this size for GIF shares on mobile
  ///
  final TenorWebm tinyWebm;

  /// `Resolution and size`: smallest size of the webm format
  ///
  /// `Dimensions`: Same as nanomp4
  ///
  /// `Usage Notes`: Use this size for GIF previews on mobile
  ///
  final TenorWebm nanoWebm;

  ///
  TenorMedia copyWith({
    TenorWebm? gif,
    TenorWebm? mediumGif,
    TenorWebm? tinyGif,
    TenorWebm? nanoGif,
    TenorMp4? mp4,
    TenorMp4? loopedMp4,
    TenorMp4? tinyMp4,
    TenorMp4? nanoMp4,
    TenorWebm? webm,
    TenorWebm? tinyWebm,
    TenorWebm? nanoWebm,
  }) {
    return TenorMedia(
      gif: gif ?? this.gif,
      mediumGif: mediumGif ?? this.mediumGif,
      tinyGif: tinyGif ?? this.tinyGif,
      nanoGif: nanoGif ?? this.nanoGif,
      mp4: mp4 ?? this.mp4,
      loopedMp4: loopedMp4 ?? this.loopedMp4,
      tinyMp4: tinyMp4 ?? this.tinyMp4,
      nanoMp4: nanoMp4 ?? this.nanoMp4,
      webm: webm ?? this.webm,
      tinyWebm: tinyWebm ?? this.tinyWebm,
      nanoWebm: nanoWebm ?? this.nanoWebm,
    );
  }

  ///
  Json toJson() {
    return <String, dynamic>{
      'gif': gif.toJson(),
      'mediumGif': mediumGif.toJson(),
      'tinyGif': tinyGif.toJson(),
      'nanoGif': nanoGif.toJson(),
      'mp4': mp4.toJson(),
      'loopedMp4': loopedMp4.toJson(),
      'tinyMp4': tinyMp4.toJson(),
      'nanoMp4': nanoMp4.toJson(),
      'webm': webm.toJson(),
      'tinyWebm': tinyWebm.toJson(),
      'nanoWebm': nanoWebm.toJson(),
    };
  }

  @override
  String toString() {
    return '''
    GifMedia(
      gif: $gif, 
      mediumgif: $mediumGif, 
      tinygif: $tinyGif, 
      nanogif: $nanoGif, 
      mp4: $mp4, 
      loopedmp4: $loopedMp4, 
      tinymp4: $tinyMp4, 
      nanomp4: $nanoMp4, 
      webm: $webm, 
      tinywebm: $tinyWebm, 
      nanowebm: $nanoWebm
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorMedia &&
        other.gif == gif &&
        other.mediumGif == mediumGif &&
        other.tinyGif == tinyGif &&
        other.nanoGif == nanoGif &&
        other.mp4 == mp4 &&
        other.loopedMp4 == loopedMp4 &&
        other.tinyMp4 == tinyMp4 &&
        other.nanoMp4 == nanoMp4 &&
        other.webm == webm &&
        other.tinyWebm == tinyWebm &&
        other.nanoWebm == nanoWebm;
  }

  @override
  int get hashCode {
    return gif.hashCode ^
        mediumGif.hashCode ^
        tinyGif.hashCode ^
        nanoGif.hashCode ^
        mp4.hashCode ^
        loopedMp4.hashCode ^
        tinyMp4.hashCode ^
        nanoMp4.hashCode ^
        webm.hashCode ^
        tinyWebm.hashCode ^
        nanoWebm.hashCode;
  }
}

///
@immutable
class TenorWebm {
  ///
  const TenorWebm({
    this.preview = '',
    this.url = '',
    this.dimension = const [0, 0],
    this.size = 0,
  });

  ///
  factory TenorWebm.fromJson(Json json) {
    return TenorWebm(
      preview: json['preview'] as String? ?? '',
      url: json['url'] as String? ?? '',
      dimension: json['dims'] as List<int>? ?? const [0, 0],
      size: json['size'] as int? ?? 0,
    );
  }

  /// A url to a preview image of the media source
  final String preview;

  /// A url to the media source
  final String url;

  /// width and height in pixels
  final List<int> dimension;

  /// size of file in bytes
  final int size;

  ///
  TenorWebm copyWith({
    String? preview,
    String? url,
    List<int>? dimension,
    int? size,
  }) {
    return TenorWebm(
      preview: preview ?? this.preview,
      url: url ?? this.url,
      dimension: dimension ?? this.dimension,
      size: size ?? this.size,
    );
  }

  ///
  Json toJson() => <String, dynamic>{
        'preview': preview,
        'url': url,
        'dims': dimension,
        'size': size,
      };

  @override
  String toString() {
    return 'WebmGif(preview: $preview, url: $url, dimension: $dimension, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorWebm &&
        other.preview == preview &&
        other.url == url &&
        listEquals(other.dimension, dimension) &&
        other.size == size;
  }

  @override
  int get hashCode {
    return preview.hashCode ^ url.hashCode ^ dimension.hashCode ^ size.hashCode;
  }
}

///
@immutable
class TenorMp4 {
  ///
  const TenorMp4({
    this.preview = '',
    this.url = '',
    this.dimension = const [0, 0],
    this.size = 0,
    this.duration = 0.0,
  });

  ///
  factory TenorMp4.fromJson(Json json) {
    return TenorMp4(
      preview: json['preview'] as String? ?? '',
      url: json['url'] as String? ?? '',
      dimension: json['dims'] as List<int>? ?? const [0, 0],
      size: json['size'] as int? ?? 0,
      duration: json['duration'] as double? ?? 0.0,
    );
  }

  /// A url to a preview image of the media source
  final String preview;

  /// A url to the media source
  final String url;

  /// width and height in pixels
  final List<int> dimension;

  /// size of file in bytes
  final int size;

  /// Duration of the media source in seconds
  final double duration;

  ///
  TenorMp4 copyWith({
    String? preview,
    String? url,
    List<int>? dimension,
    int? size,
    double? duration,
  }) {
    return TenorMp4(
      preview: preview ?? this.preview,
      url: url ?? this.url,
      dimension: dimension ?? this.dimension,
      size: size ?? this.size,
      duration: duration ?? this.duration,
    );
  }

  ///
  Json toJson() => <String, dynamic>{
        'preview': preview,
        'url': url,
        'dims': dimension,
        'size': size,
        'duration': duration,
      };

  @override
  String toString() {
    return 'Mp4Gif(preview: $preview, url: $url, dimension: $dimension, size: $size, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorMp4 &&
        other.preview == preview &&
        other.url == url &&
        listEquals(other.dimension, dimension) &&
        other.size == size &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return preview.hashCode ^
        url.hashCode ^
        dimension.hashCode ^
        size.hashCode ^
        duration.hashCode;
  }
}

///
@immutable
class TenorCategories {
  ///
  const TenorCategories({
    this.locale = '',
    this.tags = const [],
  });

  ///
  factory TenorCategories.fromJson(Json json) {
    final tags = json['tags'] as List<Json>? ?? <Json>[];
    return TenorCategories(
      locale: json['locale'] as String? ?? '',
      tags: tags.map((e) => TenorCategoryTag.fromJson(e)).toList(),
    );
  }

  ///
  final String locale;

  ///
  final List<TenorCategoryTag> tags;

  ///
  TenorCategories copyWith({
    String? locale,
    List<TenorCategoryTag>? tags,
  }) {
    return TenorCategories(
      locale: locale ?? this.locale,
      tags: tags ?? this.tags,
    );
  }

  ///
  Json toJson() => <String, dynamic>{
        'locale': locale,
        'tags': tags.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() => 'TenorCategories(locale: $locale, tags: $tags)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorCategories &&
        other.locale == locale &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode => locale.hashCode ^ tags.hashCode;
}

///
@immutable
class TenorCategoryTag {
  ///
  const TenorCategoryTag({
    this.searchTerm = '',
    this.path = '',
    this.image = '',
    this.name = '',
  });

  ///
  factory TenorCategoryTag.fromJson(Json json) {
    return TenorCategoryTag(
      searchTerm: json['searchterm'] as String? ?? '',
      path: json['path'] as String? ?? '',
      image: json['image'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  ///
  final String searchTerm;

  ///
  final String path;

  ///
  final String image;

  ///
  final String name;

  ///
  TenorCategoryTag copyWith({
    String? searchTerm,
    String? path,
    String? image,
    String? name,
  }) {
    return TenorCategoryTag(
      searchTerm: searchTerm ?? this.searchTerm,
      path: path ?? this.path,
      image: image ?? this.image,
      name: name ?? this.name,
    );
  }

  ///
  Json toJson() => <String, dynamic>{
        'searchterm': searchTerm,
        'path': path,
        'image': image,
        'name': name,
      };

  @override
  String toString() {
    return '''
    TenorCategoryTag(
      searchTerm: $searchTerm, 
      path: $path, 
      image: $image, 
      name: $name
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorCategoryTag &&
        other.searchTerm == searchTerm &&
        other.path == path &&
        other.image == image &&
        other.name == name;
  }

  @override
  int get hashCode {
    return searchTerm.hashCode ^ path.hashCode ^ image.hashCode ^ name.hashCode;
  }
}

///
@immutable
class TenorSuccess {
  ///
  const TenorSuccess({required this.status});

  ///
  factory TenorSuccess.fromJson(Json json) =>
      TenorSuccess(status: json['status'] as String);

  ///
  final String status;

  ///
  Json toJson() => <String, dynamic>{'status': status};

  @override
  String toString() => 'TenorSuccess(status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorSuccess && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}

///
@immutable
class TenorAnonymousUser {
  ///
  const TenorAnonymousUser({required this.id});

  ///
  factory TenorAnonymousUser.fromJson(Json json) =>
      TenorAnonymousUser(id: json['anonId'] as String);

  ///
  final String id;

  ///
  Json toJson() => <String, dynamic>{'anonId': id};

  @override
  String toString() => 'TenorAnonymousUser(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TenorAnonymousUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}