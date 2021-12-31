import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/entities/quary_param.dart';
import 'package:gif_picker/src/entities/tenor_response.dart';

/// 2. Trending [TrendingQuery]
/// 1. Search [SearchQuary]
/// 3. Categories [CategoriesQuery]
/// 4. Search Suggestions [SearchSuggestionsQuery]
/// 5. Autocomplete [SearchSuggestionsQuery]
/// 6. Current Trending Search Terms [TenorQuery]
/// 7. Register share [ShareRegisterQuery]
/// 8. Related gif's (GIF(s) for the corresponding id(s)) [SimilarGifQuery]
/// 9. Random gif's [SearchQuary]
/// 10. Anonymous user id. {key:String}
///

///
class TenorRepository implements IGifRepository {
  ///
  const TenorRepository({required String key}) : _apiKey = key;

  final String _apiKey;

  ///
  Future<TenorResponse> search({required SearchQuary query}) async {
    return TenorResponse();
  }

  /// Get autocomplete list
  Future<List<String>> autocomplete({
    required SearchSuggestionsQuery query,
  }) async {
    return [];
  }

  /// Get search suggestions
  Future<List<String>> getSuggestions({
    required SearchSuggestionsQuery query,
  }) async {
    return [];
  }

  /// Fetch trending gif's
  Future<List<Gif>> getTrendingGifs({required TrendingQuery query}) async {
    return [];
  }

  /// Search trending gif's
  Future<List<Gif>> searchTrending(TenorQuery query) async {
    return [];
  }

  /// Fetch gif categories
  Future<List<GifCategory>> getCategories(CategoriesQuery query) async {
    return [];
  }

  /// Register share gif event
  Future<void> registerShareEvent(ShareRegisterQuery query) async {}

  /// Get gif by id
  Future<Gif> getSimilarById(SimilarGifQuery query) async {
    return TenorGif(id: '', url: '');
  }

  /// Get random gif's
  Future<List<Gif>> getRandomGifs(SearchQuary query) async {
    return [];
  }

  /// Get anonymous user id
  Future<String> getAnonymousUserId() async {
    // key:String
    return '';
  }
}
