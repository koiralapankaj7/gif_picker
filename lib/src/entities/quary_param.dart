import 'package:flutter/material.dart';
import 'package:gif_picker/src/entities/tenor_response.dart';

///
@immutable
class TenorQuery {
  ///
  const TenorQuery({
    this.local,
    this.limit,
    this.anonymousUserId,
  });

  /// STRONGLY RECOMMENDED
  ///
  /// Specify default language to interpret search string;
  /// xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1
  /// country code
  final String? local;

  ///
  /// Fetch up to a specified number of results (max: 50)
  final int? limit;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  /// Helper function to copy object
  TenorQuery copyWith({
    String? local,
    int? limit,
    String? anonymousUserId,
  }) {
    return TenorQuery(
      local: local ?? this.local,
      limit: limit ?? this.limit,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  /// Convert object to json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (local != null) 'local': local,
      if (limit != null) 'limit': limit,
      if (anonymousUserId != null) 'anonymousUserId': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    TenorQuery(
      local: $local, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant TenorQuery other) {
    if (identical(this, other)) return true;

    return other.local == local &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return local.hashCode ^ limit.hashCode ^ anonymousUserId.hashCode;
  }
}

///
class TrendingQuery extends TenorQuery {
  ///
  const TrendingQuery({
    String? local,
    int? limit,
    String? anonymousUserId,
    this.arRange,
    this.contentFilter,
    this.mediaFilter,
    this.position,
  }) : super(
          local: local,
          limit: limit,
          anonymousUserId: anonymousUserId,
        );

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
  final ARRange? arRange;

  /// STRONGLY RECOMMENDED
  ///
  /// ( off | low | medium | high) specify the content safety filter level
  final ContentFilter? contentFilter;

  /// STRONGLY RECOMMENDED
  ///
  /// ( basic | minimal) Reduce the Number of GIF formats returned in the
  /// GIF_OBJECT list.
  ///
  /// minimal - tinygif, gif, and mp4.
  ///
  /// basic - nanomp4, tinygif, tinymp4, gif, mp4, and nanogif
  final MediaFilter? mediaFilter;

  ///
  /// Get results starting at position "value". Use a non-zero "next"
  /// value returned by API results to get the next set of results.
  /// position is not an index and may be an integer, float, or string
  final String? position;

  ///
  @override
  TrendingQuery copyWith({
    String? local,
    int? limit,
    String? anonymousUserId,
    ARRange? arRange,
    ContentFilter? contentFilter,
    MediaFilter? mediaFilter,
    String? position,
  }) {
    return TrendingQuery(
      local: local ?? this.local,
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
      if (arRange != null) 'arRange': arRange!.name,
      if (contentFilter != null) 'contentFilter': contentFilter!.name,
      if (mediaFilter != null) 'mediaFilter': mediaFilter!.name,
      if (position != null) 'position': position,
    };
  }

  @override
  String toString() {
    return '''
    TrendingQuery(
      local: $local, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
      arRange: $arRange, 
      contentFilter: $contentFilter, 
      mediaFilter: $mediaFilter, 
      position: $position
    )''';
  }

  @override
  bool operator ==(covariant TrendingQuery other) {
    if (identical(this, other)) return true;

    return other.local == local &&
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
class SearchQuary extends TrendingQuery {
  ///
  const SearchQuary({
    required this.query,
    String? local,
    ARRange? arRange,
    ContentFilter? contentFilter,
    MediaFilter? mediaFilter,
    int? limit,
    String? position,
    String? anonymousUserId,
  }) : super(
          local: local,
          arRange: arRange,
          contentFilter: contentFilter,
          mediaFilter: mediaFilter,
          limit: limit,
          position: position,
          anonymousUserId: anonymousUserId,
        );

  ///
  /// A search string
  final String query;

  ///
  @override
  SearchQuary copyWith({
    String? query,
    String? local,
    int? limit,
    String? anonymousUserId,
    ARRange? arRange,
    ContentFilter? contentFilter,
    MediaFilter? mediaFilter,
    String? position,
  }) {
    return SearchQuary(
      query: query ?? this.query,
      local: local ?? this.local,
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
    return <String, dynamic>{'query': query, ...super.toJson()};
  }

  @override
  String toString() => '''
  SearchQuary(
      query: $query,
      local: $local, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
      arRange: $arRange, 
      contentFilter: $contentFilter, 
      mediaFilter: $mediaFilter, 
      position: $position
    )''';

  @override
  bool operator ==(covariant SearchQuary other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.local == local &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId &&
        other.arRange == arRange &&
        other.contentFilter == contentFilter &&
        other.mediaFilter == mediaFilter &&
        other.position == position;
  }

  @override
  int get hashCode => super.hashCode ^ query.hashCode;
}

/// Search Suggestions Query Parameters
class SearchSuggestionsQuery extends TenorQuery {
  ///
  const SearchSuggestionsQuery({
    required this.query,
    String? local,
    int? limit,
    String? anonymousUserId,
  }) : super(
          local: local,
          limit: limit,
          anonymousUserId: anonymousUserId,
        );

  ///
  /// A search string
  final String query;

  ///
  @override
  SearchSuggestionsQuery copyWith({
    String? local,
    int? limit,
    String? anonymousUserId,
    String? query,
  }) {
    return SearchSuggestionsQuery(
      local: local ?? this.local,
      limit: limit ?? this.limit,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      query: query ?? this.query,
    );
  }

  ///
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{...super.toJson(), 'query': query};
  }

  @override
  String toString() {
    return '''
    SearchSuggestionsQuery(
      query: $query,
      local: $local, 
      limit: $limit, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant SearchSuggestionsQuery other) {
    if (identical(this, other)) return true;

    return other.query == query &&
        other.local == local &&
        other.limit == limit &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return super.hashCode ^ query.hashCode;
  }
}

///
enum CategoryType {
  /// Featured gifs
  featured,

  /// Emoji gifs
  emoji,

  /// Trending gifs
  trending,
}

/// Categories Query Parameters
@immutable
class CategoriesQuery {
  ///
  const CategoriesQuery({
    this.local,
    this.type,
    this.contentFilter,
    this.anonymousUserId,
  });

  /// STRONGLY RECOMMENDED
  ///
  /// Specify default language to interpret search string;
  /// xx is ISO 639-1 language code, _YY (optional) is 2-letter ISO 3166-1
  /// country code
  final String? local;

  /// STRONGLY RECOMMENDED
  ///
  /// ( featured | emoji | trending ) determines the type of categories returned
  final CategoryType? type;

  /// STRONGLY RECOMMENDED
  ///
  /// ( off | low | medium | high) specify the content safety filter level
  final ContentFilter? contentFilter;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  ///
  CategoriesQuery copyWith({
    String? local,
    CategoryType? type,
    ContentFilter? contentFilter,
    String? anonymousUserId,
  }) {
    return CategoriesQuery(
      local: local ?? this.local,
      type: type ?? this.type,
      contentFilter: contentFilter ?? this.contentFilter,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (local != null) 'local': local,
      if (type != null) 'type': type!.name,
      if (local != null) 'contentFilter': contentFilter!.name,
      if (anonymousUserId != null) 'anonymousUserId': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    CategoriesQuery(
      local: $local, 
      type: $type, 
      contentFilter: $contentFilter, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant CategoriesQuery other) {
    if (identical(this, other)) return true;

    return other.local == local &&
        other.type == type &&
        other.contentFilter == contentFilter &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return local.hashCode ^
        type.hashCode ^
        contentFilter.hashCode ^
        anonymousUserId.hashCode;
  }
}

///
@immutable
class ShareRegisterQuery {
  ///
  const ShareRegisterQuery({
    required this.id,
    this.query,
    this.local,
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
  final String? local;

  ///
  /// Specify the anonymous id tied to the given user
  final String? anonymousUserId;

  ///
  ShareRegisterQuery copyWith({
    String? id,
    String? query,
    String? local,
    String? anonymousUserId,
  }) {
    return ShareRegisterQuery(
      id: id ?? this.id,
      query: query ?? this.query,
      local: local ?? this.local,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      if (query != null) 'query': query,
      if (local != null) 'local': local,
      if (anonymousUserId != null) 'anonymousUserId': anonymousUserId,
    };
  }

  @override
  String toString() {
    return '''
    RegisterShareQuery(
      id: $id, 
      query: $query, 
      local: $local, 
      anonymousUserId: $anonymousUserId
    )''';
  }

  @override
  bool operator ==(covariant ShareRegisterQuery other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.query == query &&
        other.local == local &&
        other.anonymousUserId == anonymousUserId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        query.hashCode ^
        local.hashCode ^
        anonymousUserId.hashCode;
  }
}

///
@immutable
class SimilarGifQuery {
  ///
  const SimilarGifQuery({
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
  final MediaFilter? mediaFilter;

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
  SimilarGifQuery copyWith({
    String? ids,
    MediaFilter? mediaFilter,
    int? limit,
    String? position,
    String? anonymousUserId,
  }) {
    return SimilarGifQuery(
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
      if (mediaFilter != null) 'mediaFilter': mediaFilter!.name,
      if (limit != null) 'limit': limit,
      if (position != null) 'position': position,
      if (anonymousUserId != null) 'anonymousUserId': anonymousUserId,
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
  bool operator ==(covariant SimilarGifQuery other) {
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
