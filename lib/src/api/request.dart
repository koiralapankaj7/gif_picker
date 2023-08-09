// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

///
@immutable
class TenorQuery {
  ///
  const TenorQuery({
    this.locale,
    this.limit,
    this.anonymousUserId,
  });

  /// STRONGLY RECOMMENDED
  ///
  /// Specify default language to interpret search string;
  /// xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1
  /// country code
  final String? locale;

  ///
  /// Fetch up to a specified number of results (max: 50)
  final int? limit;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  /// Helper function to copy object
  TenorQuery copyWith({
    String? locale,
    int? limit,
    String? anonymousUserId,
  }) {
    return TenorQuery(
      locale: locale ?? this.locale,
      limit: limit ?? this.limit,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  /// Convert object to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (locale != null) 'locale': locale,
      if (limit != null) 'limit': limit,
      if (anonymousUserId != null) 'anon_id': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    TenorQuery(
      locale: $locale, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant TenorQuery other) {
    if (identical(this, other)) return true;

    return other.locale == locale &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return locale.hashCode ^ limit.hashCode ^ anonymousUserId.hashCode;
  }
}

///
class TenorTrendingQuery extends TenorQuery {
  ///
  const TenorTrendingQuery({
    super.locale,
    super.limit,
    super.anonymousUserId,
    this.arRange,
    this.contentFilter,
    this.mediaFilter,
    this.position,
  });

  /// STRONGLY RECOMMENDED
  ///
  /// (values: all | wide | standard ) Filter the response GIF_OBJECT list
  /// to only include GIFs with aspect ratios that fit with in the selected
  /// range.
  ///
  /// all - no constraints
  ///
  /// wide - 0.42 <= aspect ratio <= 2.36
  ///
  /// standard - .56 <= aspect ratio <= 1.78
  final TenorARRange? arRange;

  /// STRONGLY RECOMMENDED
  ///
  /// ( off | low | medium | high) specify the content safety filter level
  final TenorContentFilter? contentFilter;

  /// STRONGLY RECOMMENDED
  ///
  /// ( basic | minimal) Reduce the Number of GIF formats returned in the
  /// GIF_OBJECT list.
  ///
  /// minimal - tinygif, gif, and mp4.
  ///
  /// basic - nanomp4, tinygif, tinymp4, gif, mp4, and nanogif
  final TenorMediaFilter? mediaFilter;

  ///
  /// Get results starting at position "value". Use a non-zero "next"
  /// value returned by API results to get the next set of results.
  /// position is not an index and may be an integer, float, or string
  final String? position;

  ///
  @override
  TenorTrendingQuery copyWith({
    String? locale,
    int? limit,
    String? anonymousUserId,
    TenorARRange? arRange,
    TenorContentFilter? contentFilter,
    TenorMediaFilter? mediaFilter,
    String? position,
  }) {
    return TenorTrendingQuery(
      locale: locale ?? this.locale,
      limit: limit ?? this.limit,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      arRange: arRange ?? this.arRange,
      contentFilter: contentFilter ?? this.contentFilter,
      mediaFilter: mediaFilter ?? this.mediaFilter,
      position: position ?? this.position,
    );
  }

  ///
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ...super.toJson(),
      if (arRange != null) 'ar_range': arRange!.name,
      if (contentFilter != null) 'contentfilter': contentFilter!.name,
      if (mediaFilter != null) 'media_filter': mediaFilter!.name,
      if (position != null) 'pos': position,
    };
  }

  @override
  String toString() {
    return '''
    TrendingQuery(
      locale: $locale, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
      arRange: $arRange, 
      contentFilter: $contentFilter, 
      mediaFilter: $mediaFilter, 
      position: $position
    )''';
  }

  @override
  bool operator ==(covariant TenorTrendingQuery other) {
    if (identical(this, other)) return true;

    return other.locale == locale &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId &&
        other.arRange == arRange &&
        other.contentFilter == contentFilter &&
        other.mediaFilter == mediaFilter &&
        other.position == position;
  }

  @override
  int get hashCode {
    return super.hashCode ^
        arRange.hashCode ^
        contentFilter.hashCode ^
        mediaFilter.hashCode ^
        position.hashCode;
  }
}

/// Search Query Parameters
class TenorSearchQuary extends TenorTrendingQuery {
  ///
  const TenorSearchQuary({
    required this.query,
    super.locale,
    super.arRange,
    super.contentFilter,
    super.mediaFilter,
    super.limit,
    super.position,
    super.anonymousUserId,
    this.isEmoji = false,
  });

  ///
  /// A search string
  final String query;

  /// Set value to true if you are searching emoji
  final bool isEmoji;

  ///
  @override
  TenorSearchQuary copyWith({
    String? query,
    String? locale,
    int? limit,
    String? anonymousUserId,
    TenorARRange? arRange,
    TenorContentFilter? contentFilter,
    TenorMediaFilter? mediaFilter,
    String? position,
    bool? isEmoji,
  }) {
    return TenorSearchQuary(
      query: query ?? this.query,
      locale: locale ?? this.locale,
      limit: limit ?? this.limit,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      arRange: arRange ?? this.arRange,
      contentFilter: contentFilter ?? this.contentFilter,
      mediaFilter: mediaFilter ?? this.mediaFilter,
      position: position ?? this.position,
      isEmoji: isEmoji ?? this.isEmoji,
    );
  }

  ///
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (!isEmoji) 'q': query,
      if (isEmoji) 'tag': query,
      ...super.toJson(),
    };
  }

  @override
  String toString() => '''
  SearchQuary(
      query: $query,
      locale: $locale, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
      arRange: $arRange, 
      contentFilter: $contentFilter, 
      mediaFilter: $mediaFilter, 
      position: $position,
      isEmoji: $isEmoji
    )''';

  @override
  bool operator ==(covariant TenorSearchQuary other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.locale == locale &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId &&
        other.arRange == arRange &&
        other.contentFilter == contentFilter &&
        other.mediaFilter == mediaFilter &&
        other.position == position &&
        other.isEmoji == isEmoji;
  }

  @override
  int get hashCode => super.hashCode ^ query.hashCode ^ isEmoji.hashCode;
}

/// Search Suggestions Query Parameters
class TenorSearchSuggestionsQuery extends TenorQuery {
  ///
  const TenorSearchSuggestionsQuery({
    required this.query,
    super.locale,
    super.limit,
    super.anonymousUserId,
  });

  ///
  /// A search string
  final String query;

  ///
  @override
  TenorSearchSuggestionsQuery copyWith({
    String? locale,
    int? limit,
    String? anonymousUserId,
    String? query,
  }) {
    return TenorSearchSuggestionsQuery(
      locale: locale ?? this.locale,
      limit: limit ?? this.limit,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      query: query ?? this.query,
    );
  }

  ///
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{...super.toJson(), 'q': query};
  }

  @override
  String toString() {
    return '''
    SearchSuggestionsQuery(
      query: $query,
      locale: $locale, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant TenorSearchSuggestionsQuery other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.locale == locale &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return super.hashCode ^ query.hashCode;
  }
}

/// Categories Query Parameters
@immutable
class TenorCategoriesQuery {
  ///
  const TenorCategoriesQuery({
    this.locale,
    this.type,
    this.contentFilter,
    this.anonymousUserId,
  });

  /// STRONGLY RECOMMENDED
  ///
  /// Specify default language to interpret search string;
  /// xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1
  /// country code
  final String? locale;

  /// STRONGLY RECOMMENDED
  ///
  /// ( featured | emoji | trending ) determines the type of categories returned
  final TenorCategoryType? type;

  /// STRONGLY RECOMMENDED
  ///
  /// ( off | low | medium | high) specify the content safety filter level
  final TenorContentFilter? contentFilter;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  ///
  TenorCategoriesQuery copyWith({
    String? locale,
    TenorCategoryType? type,
    TenorContentFilter? contentFilter,
    String? anonymousUserId,
  }) {
    return TenorCategoriesQuery(
      locale: locale ?? this.locale,
      type: type ?? this.type,
      contentFilter: contentFilter ?? this.contentFilter,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (locale != null) 'locale': locale,
      if (type != null) 'type': type!.name,
      if (locale != null) 'contentfilter': contentFilter!.name,
      if (anonymousUserId != null) 'anon_id': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    CategoriesQuery(
      locale: $locale, 
      type: $type, 
      contentFilter: $contentFilter, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant TenorCategoriesQuery other) {
    if (identical(this, other)) return true;

    return other.locale == locale &&
        other.type == type &&
        other.contentFilter == contentFilter &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return locale.hashCode ^
        type.hashCode ^
        contentFilter.hashCode ^
        anonymousUserId.hashCode;
  }
}

///
@immutable
class TenorRegisterShareQuery {
  ///
  const TenorRegisterShareQuery({
    required this.id,
    this.query,
    this.locale,
    this.anonymousUserId,
  });

  ///
  /// the “id” of a GIF_OBJECT
  final String id;

  ///
  /// The search string that lead to this share
  final String? query;

  /// STRONGLY RECOMMENDED
  ///
  /// Specify default language to interpret search string;
  /// xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1
  /// country code
  final String? locale;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  ///
  TenorRegisterShareQuery copyWith({
    String? id,
    String? query,
    String? locale,
    String? anonymousUserId,
  }) {
    return TenorRegisterShareQuery(
      id: id ?? this.id,
      query: query ?? this.query,
      locale: locale ?? this.locale,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      if (query != null) 'q': query,
      if (locale != null) 'locale': locale,
      if (anonymousUserId != null) 'anon_id': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    RegisterShareQuery(
      id: $id, 
      query: $query, 
      locale: $locale, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant TenorRegisterShareQuery other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.query == query &&
        other.locale == locale &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        query.hashCode ^
        locale.hashCode ^
        anonymousUserId.hashCode;
  }
}

///
@immutable
class TenorCorrespondingGifsQuery {
  ///
  const TenorCorrespondingGifsQuery({
    required this.ids,
    this.mediaFilter,
    this.limit,
    this.position,
    this.anonymousUserId,
  });

  ///
  /// A comma separated list of GIF IDs (max: 50)
  final String ids;

  /// STRONGLY RECOMMENDED
  ///
  /// ( basic | minimal) Reduce the Number of GIF formats returned in the
  /// GIF_OBJECT list.
  ///
  /// minimal - tinygif, gif, and mp4.
  ///
  /// basic - nanomp4, tinygif, tinymp4, gif, mp4, and nanogif
  final TenorMediaFilter? mediaFilter;

  ///
  /// Fetch up to a specified number of results (max: 50)
  final int? limit;

  ///
  /// Get results starting at position "value". Use a non-zero "next"
  /// value returned by API results to get the next set of results.
  /// position is not an index and may be an integer, float, or string
  final String? position;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  ///
  TenorCorrespondingGifsQuery copyWith({
    String? ids,
    TenorMediaFilter? mediaFilter,
    int? limit,
    String? position,
    String? anonymousUserId,
  }) {
    return TenorCorrespondingGifsQuery(
      ids: ids ?? this.ids,
      mediaFilter: mediaFilter ?? this.mediaFilter,
      limit: limit ?? this.limit,
      position: position ?? this.position,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ids': ids,
      if (mediaFilter != null) 'media_filter': mediaFilter!.name,
      if (limit != null) 'limit': limit,
      if (position != null) 'pos': position,
      if (anonymousUserId != null) 'anon_id': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    SimilarGifsQuery(
      ids: $ids, 
      mediaFilter: $mediaFilter, 
      limit: $limit, 
      position: $position, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant TenorCorrespondingGifsQuery other) {
    if (identical(this, other)) return true;

    return other.ids == ids &&
        other.mediaFilter == mediaFilter &&
        other.limit == limit &&
        other.position == position &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return ids.hashCode ^
        mediaFilter.hashCode ^
        limit.hashCode ^
        position.hashCode ^
        anonymousUserId.hashCode;
  }
}

/// Reduce the Number of GIF formats returned in the GIF_OBJECT list.
///
/// `gif`
/// * Resolution and size: High quality GIF format, largest file size available
/// * Dimensions: Original upload dimensions (no limits)
/// * Usage Notes: Use this size for GIF shares on desktop
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none], [TenorMediaFilter.basic] & [TenorMediaFilter.minimal]
///
/// `mediumgif`
/// * Resolution and size: small reduction in size of the GIF format
/// * Dimensions: Original upload dimensions (no limits) but much higher compression rate
/// * Usage Notes: Use this size for GIF previews on desktop
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none]
///
/// `tinygif`
/// * Resolution and size: reduced size of the GIF format
/// * Dimensions: Up to 220 pixels wide, Height scaled with aspect ratio reserved
/// * Usage Notes: Use this size for GIF previews and shares on mobile
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none], [TenorMediaFilter.basic] & [TenorMediaFilter.minimal]
///
/// `nanogif`
/// * Resolution and size: smallest size of the GIF format
/// * Dimensions: Up to 90 pixels tall, Width scaled with aspect ratio preserved
/// * Usage Notes: Use this size for GIF previews on mobile
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none] & [TenorMediaFilter.basic]
///
/// `mp4`
/// * Resolution and size: highest quality video format, largest of the video formats, but smaller than GIF
/// * Dimensions: Similar to gif, but padded to fit video container specifications (usually 8-pixel increments)
/// * Usage Notes: Use this size for MP4 previews and shares on desktop
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none], [TenorMediaFilter.basic] & [TenorMediaFilter.minimal]
///
/// `loopedmp4`
/// * Resolution and size: highest quality video format, larger in size than mp4
/// * Dimensions: Same as mp4
/// * Usage Notes: Use this size for mp4 shares if you want the video clip to run a few times rather than only once
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none]
///
/// `tinymp4`
/// * Resolution and size: reduced size of the mp4 format
/// * Dimensions: Variable width and height, with maximum bounding box of 320x320
/// * Usage Notes: Use this size for mp4 previews and shares on mobile
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none] & [TenorMediaFilter.basic]
///
/// `nanomp4`
/// * Resolution and size: smallest size of the mp4 format
/// * Dimensions: Variable width and height, with maximum bounding box of 150x150
/// * Usage Notes: Use this size for webm previews and shares on desktop
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none] & [TenorMediaFilter.basic]
///
/// `webm`
/// * Resolution and size: Lower quality video format, smaller in size than MP4
/// * Dimensions: Same as mp4
/// * Usage Notes: Use this size for webm previews and shares on desktop
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none]
///
/// `tinywebm`
/// * Resolution and size: reduced size of the webm format
/// * Dimensions: Same as tinymp4
/// * Usage Notes: Use this size for GIF shares on mobile
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none]
///
/// `nanowebm`
/// * Resolution and size: smallest size of the webm format
/// * Dimensions: Same as nanomp4
/// * Usage Notes: Use this size for GIF previews on mobile
/// * MEDIA FILTERS SUPPORTED: [TenorMediaFilter.none]
///
/// For more details please see: https://tenor.com/gifapi/documentation#responseobjects-gifformat
class TenorMediaFilter {
  const TenorMediaFilter._inernal(this.name);

  ///
  final String name;

  /// All format will be applicable
  ///
  /// gif, mediumgif, tinygif, nanogif, mp4, loopedmp4, tinymp4, nanomp4, webm,
  /// tinywebm, nanowebm
  static const TenorMediaFilter none = TenorMediaFilter._inernal('default');

  /// nanomp4, tinygif, tinymp4, gif, mp4, and nanogif
  static const TenorMediaFilter basic = TenorMediaFilter._inernal('basic');

  /// tinygif, gif, and mp4
  static const TenorMediaFilter minimal = TenorMediaFilter._inernal('minimal');

  ///
  static const List<TenorMediaFilter> values = <TenorMediaFilter>[
    none,
    basic,
    minimal,
  ];
}

/// determines the type of categories returned
enum TenorCategoryType {
  /// Featured gifs
  featured,

  /// Emoji gifs
  emoji,

  /// Trending gifs
  trending,
}

///
/// Content safety filter level
///
/// Tenor offer flexible content filters that enable you to offer the type of
/// content that is the best fit for your users. Tenor filters are designed
/// to map to the MPAA though important to note tenor do not surface the type
/// of nudity that may be found in R rated films. If you become aware of
/// such content, please inform tenor immediately by contacting
/// support@tenor.com.
///
/// Note: this feature was previously called SafeSearch in tenor.
///
/// For more details, see: https://tenor.com/gifapi/documentation#contentfilter
///
enum TenorContentFilter {
  /// G, PG, PG-13, and R (no nudity)
  off,

  /// G, PG, and PG-13
  low,

  /// G and PG
  medium,

  /// G
  high,
}

/// Gif aspect ratio range
enum TenorARRange {
  /// No constraints will be applicable
  all,

  /// 0.42 <= aspect ratio <= 2.36
  wide,

  /// .56 <= aspect ratio <= 1.78
  standard,
}

///
extension StringX on String {
  /// Convert string to [TenorARRange]
  TenorARRange get arRange {
    switch (this) {
      case 'wide':
        return TenorARRange.wide;
      case 'standard':
        return TenorARRange.standard;
      default:
        return TenorARRange.all;
    }
  }

  /// Convert string to [TenorContentFilter]
  TenorContentFilter get contentFilter {
    switch (this) {
      case 'low':
        return TenorContentFilter.low;
      case 'medium':
        return TenorContentFilter.medium;
      case 'high':
        return TenorContentFilter.high;
      default:
        return TenorContentFilter.off;
    }
  }

  /// Convert string to [TenorMediaFilter]
  TenorMediaFilter get mediaFilter {
    switch (this) {
      case 'basic':
        return TenorMediaFilter.basic;
      case 'minimal':
        return TenorMediaFilter.minimal;
      default:
        return TenorMediaFilter.none;
    }
  }
}
