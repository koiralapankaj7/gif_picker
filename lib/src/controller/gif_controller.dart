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
  Future<void> fetchCategories({TenorCategoriesQuery? query}) async {
    _assert(TenorCategories);
    value = const BaseState.loading();
    try {
      final categories = await _api.getCategories(query: query);
      value = BaseState.success(categories as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Autocomplete terms
  Future<void> fetchAutoCompleteTerms({
    required TenorSearchSuggestionsQuery query,
  }) async {
    _assert(TenorTerms);
    value = const BaseState.loading();
    try {
      final terms = await _api.autoComplete(query: query);
      value = BaseState.success(terms as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Suggestions terms
  Future<void> fetchSuggestions({
    required TenorSearchSuggestionsQuery query,
  }) async {
    _assert(TenorTerms);
    value = const BaseState.loading();
    try {
      final terms = await _api.getSuggestions(query: query);
      value = BaseState.success(terms as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Trending search terms
  Future<void> fetchTrendingSearchTerms({TenorQuery? query}) async {
    _assert(TenorTerms);
    value = const BaseState.loading();
    try {
      final terms = await _api.getTrendingSearchTerms(query: query);
      value = BaseState.success(terms as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> search({required TenorSearchQuary query}) async {
    _assert(TenorCollection);
    value = const BaseState.loading();
    // try {
    final collection = await _api.search(query: query);
    value = BaseState.success(collection as T);
    // } on TenorNetworkError catch (e) {
    //   value = BaseState.error(e);
    // } catch (e) {
    //   value = BaseState.error(GifPickerError.fromException(e));
    // }
  }

  ///
  Future<void> fetchCorrespondingGifs({
    required TenorCorrespondingGifsQuery query,
  }) async {
    _assert(TenorCollection);
    value = const BaseState.loading();
    try {
      final collection = await _api.getCorrespondingGifs(query: query);
      value = BaseState.success(collection as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> fetchRandomGifs({required TenorSearchQuary query}) async {
    _assert(TenorCollection);
    value = const BaseState.loading();
    try {
      final collection = await _api.getRandomGifs(query: query);
      value = BaseState.success(collection as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  /// Autocomplete terms
  Future<void> fetchTrendingGifs({TenorTrendingQuery? query}) async {
    _assert(TenorTrending);
    value = const BaseState.loading();
    try {
      final trending = await _api.getTrendingGifs(query: query);
      value = BaseState.success(trending as T);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e));
    }
  }

  ///
  Future<void> registerShareEvent({
    required TenorRegisterShareQuery query,
  }) async {
    _assert(TenorSuccess);
    value = const BaseState.loading();
    try {
      final success = await _api.registerShareEvent(query: query);
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
