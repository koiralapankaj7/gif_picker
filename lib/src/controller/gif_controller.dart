import 'package:gif_picker/gif_picker.dart';

///
class GifController<T> extends BaseNotifier<T> {
  ///
  GifController() : _api = TenorApi();

  ///
  final TenorApi _api;

  ///
  void _assert(Type type) {
    assert(
      T == type,
      '''Action performed using wrong controller. Please check the type of the controller.''',
    );
  }

  ///
  Future<void> fetchCategories(TenorCategoriesQuery? query) async {
    _assert(TenorCategories);
    value = const BaseState.loading();
    try {
      final categories = await _api.getCategories(
        query ?? const TenorCategoriesQuery(),
      );
      value = BaseState.success(categories as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Autocomplete terms
  Future<void> fetchAutoCompleteTerms({
    required String query,
    TenorSearchSuggestionsQuery? queryParams,
  }) async {
    _assert(TenorTerms);
    value = const BaseState.loading();
    try {
      final terms = await _api.autoComplete(
        query: queryParams ?? TenorSearchSuggestionsQuery(query: query),
      );
      value = BaseState.success(terms as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Suggestions terms
  Future<void> fetchSuggestions({
    required String query,
    TenorSearchSuggestionsQuery? queryParams,
  }) async {
    _assert(TenorTerms);
    value = const BaseState.loading();
    try {
      final terms = await _api.getSuggestions(
        query: queryParams ?? TenorSearchSuggestionsQuery(query: query),
      );
      value = BaseState.success(terms as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Trending search terms
  Future<void> fetchTrendingSearchTerms({TenorQuery? queryParams}) async {
    _assert(TenorTerms);
    value = const BaseState.loading();
    try {
      final terms = await _api.getTrendingSearchTerms(
        queryParams ?? const TenorQuery(),
      );
      value = BaseState.success(terms as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> search({
    required String query,
    TenorSearchQuary? queryParams,
  }) async {
    _assert(TenorCollection);
    value = const BaseState.loading();
    try {
      final collection = await _api.search(
        query: queryParams ?? TenorSearchQuary(query: query),
      );
      value = BaseState.success(collection as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> fetchCorrespondingGifs({
    required String ids,
    TenorCorrespondingGifsQuery? queryParams,
  }) async {
    _assert(TenorCollection);
    value = const BaseState.loading();
    try {
      final collection = await _api.getCorrespondingGifs(
        queryParams ?? TenorCorrespondingGifsQuery(ids: ids),
      );
      value = BaseState.success(collection as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> fetchRandomGifs({
    required String query,
    TenorSearchQuary? queryParams,
  }) async {
    _assert(TenorCollection);
    value = const BaseState.loading();
    try {
      final collection = await _api.getRandomGifs(
        queryParams ?? TenorSearchQuary(query: query),
      );
      value = BaseState.success(collection as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Autocomplete terms
  Future<void> fetchTrendingGifs({TenorTrendingQuery? queryParams}) async {
    _assert(TenorTrending);
    value = const BaseState.loading();
    try {
      final trending = await _api.getTrendingGifs(
        query: queryParams ?? const TenorTrendingQuery(),
      );
      value = BaseState.success(trending as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> registerShareEvent({
    required String id,
    TenorRegisterShareQuery? queryParams,
  }) async {
    _assert(TenorSuccess);
    value = const BaseState.loading();
    try {
      final success = await _api.registerShareEvent(
        queryParams ?? TenorRegisterShareQuery(id: id),
      );
      value = BaseState.success(success as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> getAnonymousUserId() async {
    _assert(TenorAnonymousUser);
    value = const BaseState.loading();
    try {
      final user = await _api.getAnonymousUserId();
      value = BaseState.success(user as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }
}
