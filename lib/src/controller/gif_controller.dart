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
  Future<void> loadMore() async {
    _assert(TenorCollection);
    if (value is! SuccessState<TenorCollection>) return;
    final state = value as SuccessState<TenorCollection>;
    if (state.data.nextNum == 0) return;

    final type = state.extra['type'] as TenorCollectionType;

    try {
      late Future<TenorCollection> request;

      switch (type) {
        case TenorCollectionType.trending:
          final query = (state.extra['query'] as TenorTrendingQuery)
              .copyWith(position: state.data.next);
          request = _api.getTrendingGifs(query: query);
          break;
        case TenorCollectionType.correspodingGifs:
          final query = (state.extra['query'] as TenorCorrespondingGifsQuery)
              .copyWith(position: state.data.next);
          request = _api.getCorrespondingGifs(query: query);
          break;
        case TenorCollectionType.random:
          final query = (state.extra['query'] as TenorSearchQuary)
              .copyWith(position: state.data.next);
          request = _api.getRandomGifs(query: query);
          break;
        case TenorCollectionType.search:
          final query = (state.extra['query'] as TenorSearchQuary)
              .copyWith(position: state.data.next);
          request = _api.search(query: query);
          break;
      }

      final collection = await request;

      value = state.copyWith(
        data: collection.copyWith(
          items: [...state.data.items, ...collection.items],
          next: collection.next,
        ),
      ) as SuccessState<T>;
    } on TenorNetworkError catch (e) {
      value = state.copyWith(error: e) as SuccessState<T>;
    } catch (e) {
      value = state.copyWith(error: GifPickerError.fromException(e))
          as SuccessState<T>;
    }
  }

  ///
  Future<void> fetchCategories(TenorCategoriesQuery query) async {
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
  Future<void> fetchAutoCompleteTerms(TenorSearchSuggestionsQuery query) async {
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
  Future<void> fetchSuggestions(TenorSearchSuggestionsQuery query) async {
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
  Future<void> fetchTrendingSearchTerms(TenorQuery query) async {
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
  Future<void> search(TenorSearchQuary query) async {
    _assert(TenorCollection);
    final extra = <String, dynamic>{
      'type': TenorCollectionType.search,
      'query': query,
    };

    value = BaseState.loading(extra: extra);

    try {
      final collection = await _api.search(query: query);
      value = BaseState.success(collection as T, extra: extra);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e, extra: extra);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e), extra: extra);
    }
  }

  ///
  Future<void> fetchCorrespondingGifs(TenorCorrespondingGifsQuery query) async {
    _assert(TenorCollection);
    final extra = <String, dynamic>{
      'type': TenorCollectionType.correspodingGifs,
      'query': query,
    };

    value = BaseState.loading(extra: extra);
    try {
      final collection = await _api.getCorrespondingGifs(query: query);
      value = BaseState.success(collection as T, extra: extra);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e, extra: extra);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e), extra: extra);
    }
  }

  ///
  Future<void> fetchRandomGifs(TenorSearchQuary query) async {
    _assert(TenorCollection);
    final extra = <String, dynamic>{
      'type': TenorCollectionType.random,
      'query': query,
    };

    value = BaseState.loading(extra: extra);
    try {
      final collection = await _api.getRandomGifs(query: query);
      value = BaseState.success(collection as T, extra: extra);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e, extra: extra);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e), extra: extra);
    }
  }

  /// Autocomplete terms
  Future<void> fetchTrendingGifs(TenorTrendingQuery query) async {
    _assert(TenorCollection);
    final extra = <String, dynamic>{
      'type': TenorCollectionType.trending,
      'query': query,
    };

    value = BaseState.loading(extra: extra);
    try {
      final trending = await _api.getTrendingGifs(query: query);
      value = BaseState.success(trending as T, extra: extra);
    } on TenorNetworkError catch (e) {
      value = BaseState.error(e, extra: extra);
    } catch (e) {
      value = BaseState.error(GifPickerError.fromException(e), extra: extra);
    }
  }

  ///
  Future<void> registerShareEvent(TenorRegisterShareQuery query) async {
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
