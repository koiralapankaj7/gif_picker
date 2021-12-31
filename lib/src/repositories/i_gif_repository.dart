import 'package:gif_picker/gif_picker.dart';

///
abstract class IGifRepository {
  /// Search gif's by keyword
  Future<List<Gif>> search(String keyword);

  /// Get autocomplete list
  Future<List<String>> autocomplete(String keyword);

  /// Get search suggestions
  Future<List<String>> getSuggestions();

  /// Fetch trending gif's
  Future<List<Gif>> getTrendingGifs();

  /// Search trending gif's
  Future<List<Gif>> searchTrending(String keyword);

  /// Fetch gif categories
  Future<List<GifCategory>> getCategories();

  /// Register share gif event
  Future<void> registerShareEvent(String gifId);

  /// Get gif by id
  Future<Gif> getGifById(String id);

  /// Get random gif's
  Future<List<Gif>> getRandomGifs();

  /// Get anonymous user id
  Future<String> getAnonymousUserId();
}
