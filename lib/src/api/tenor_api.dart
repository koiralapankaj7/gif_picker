import 'package:gif_picker/src/api/apis.dart';
import 'package:gif_picker/src/http/gif_http_client.dart';

///
class TenorApi {
  ///
  TenorApi({GifPickerClient? client}) : _client = client ?? GifPickerClient();

  ///
  final GifPickerClient _client;

  /// Get a json object containing a list of the most relevant GIFs for a given
  /// search term(s), category(ies), emoji(s), or any combination thereof.
  ///
  /// `Best Practices:`
  ///
  /// 1. Provide the user’s search as typed, including punctuation and
  ///    special characters.
  ///
  /// 2. Use the Locale parameter. As Tenor’s service evolves, locale will be
  ///    used to better tune search results to your users’ specific languages,
  ///    cultures, and social trends. Using Locale will give higher preference
  ///    to the user’s given locale, though it will not limit search results
  ///    to only the provided code and language typed, but gives higher
  ///    preference to the given locale. The default value is en_US.
  ///
  /// 3. When a user decides which GIF to share, you should also include
  ///    a corresponding call to Register Share. This optional call helps
  ///    Tenor’s Search Engine AI tune results.
  ///
  /// 4. Use the limit and pos parameters to control the amount and flow of
  ///    GIFs returned. For example, set limit = 10 for the user’s initial
  ///    results of a given search and load previews of those GIFs for the
  ///    user to browse. If the user requests more results, collect the next
  ///    10 results by making the same API call but with pos = the “next”
  ///    field from the initial response. This pattern can be used to create
  ///    a smooth lazy loading experience. Doing so will help keep bandwidth
  ///    usage down and provide a quicker response time for the user — as
  ///    less GIF previews will need to be loaded in parallel on the
  ///    client’s side.
  ///
  /// 5. Use the ContentFilter parameter to maintain your internal content
  ///    safety ratings for GIFs returned. The default value is off
  ///
  /// 6. Use the media_filter parameter to reduce the number of GIF formats
  ///    returned. This can reduce the response object size by 25-75%.
  ///
  /// 7. Use the ar_range parameter to filter the GIF response list to only
  ///    include aspect ratios that fall within the selected range.
  Future<TenorCollection> search({required TenorSearchQuary query}) async {
    final response = await _client.get<Json>(
      '/search',
      queryParameters: query.toJson(),
    );
    return TenorCollection.fromJson(response.data ?? emptyJson);
  }

  /// Get a json object containing a list of completed search terms given a
  /// partial search term. The list is sorted by Tenor’s AI and the number of
  /// results will decrease as Tenor’s AI becomes more certain.
  ///
  /// `Best Practices:`
  ///
  /// 1. Use the Locale parameter. As Tenor’s service evolves, locale will be
  ///    used to better tune search results to your users’ specific languages,
  ///    cultures, and social trends. Using Locale will give higher preference
  ///    to the user’s given locale, though it will not limit search results to
  ///    only the provided code and language typed, but gives higher preference
  ///    to the given locale. The default value is en_US.
  ///
  /// 2, Display the results in the order provided by the response object.
  Future<TenorTerms> autocomplete({
    required TenorSearchSuggestionsQuery query,
  }) async {
    final response = await _client.get<Json>(
      '/autocomplete',
      queryParameters: query.toJson(),
    );
    return TenorTerms.fromJson(response.data ?? emptyJson);
  }

  /// Get a json object containing a list of alternative search terms given a
  /// search term.
  ///
  /// Search suggestions helps a user narrow their search or discover related
  /// search terms to find a more precise GIF. Results are returned in order of
  /// what is most likely to drive a share for a given term, based on historic
  /// user search and share behavior.
  ///
  /// `Best Practices:`
  ///
  /// 1. Use the Locale parameter. As Tenor’s service evolves, locale will be
  ///    used to better tune search results to your users’ specific languages,
  ///    cultures, and social trends. Using Locale will give higher preference
  ///    to the user’s given locale, though it will not limit search results
  ///    to only the provided code and language typed, but gives higher
  ///    preference to the given locale. The default value is en_US.
  ///
  /// 2. Display the results in the order provided by the response object.
  Future<TenorTerms> getSuggestions({
    required TenorSearchSuggestionsQuery query,
  }) async {
    final response = await _client.get<Json>(
      '/search_suggestions',
      queryParameters: query.toJson(),
    );
    return TenorTerms.fromJson(response.data ?? emptyJson);
  }

  /// Get a json object containing a list of the current global trending GIFs.
  /// The trending stream is updated regularly throughout the day.
  ///
  /// `Best Practices:`
  ///
  /// 1. Use the Locale parameter. As Tenor’s service evolves, locale will be
  ///    used to better tune search results to your users’ specific languages,
  ///    cultures, and social trends. Using Locale will give higher preference
  ///    to the user’s given locale, though it will not limit trending results
  ///    to only the provided code and language typed, but gives higher
  ///    preference to the given locale. The default value is en_US.
  ///
  /// 2. When a user decides which GIF to share, you should also include a
  ///    corresponding call to Register Share. This optional call helps Tenor’s
  ///    Search Engine AI tune results.
  ///
  /// 3. Use the Limit and Pos parameters to control the amount and flow of
  ///    GIFs returned and ultimately loaded. For example, set limit = 10 for
  ///    the user’s initial results of a trending request and load previews of
  ///    those GIFs for the user to browse. If the user requests more results,
  ///    collect the next 10 results by making the same API call but with
  ///    Pos = the “next” field from the initial response. This pattern can
  ///    be used to create a smooth lazy loading experience.
  ///    Doing so will help keep bandwidth usage down and provide a
  ///    quicker response time for the user as less GIF previews will need to
  ///    be loaded in parallel on client side.
  ///
  /// 4. Use the ContentFilter Parameter to specify the appropriate GIF
  ///    content safety rating for your service or application.
  ///
  /// 5. Use the media_filter parameter to reduce the number of GIF formats
  ///    returned. This can reduce the response object size by 25-75%.
  ///
  /// 6. Use the ar_range parameter to filter the GIF response list to only
  ///    include aspect ratios that fall within the selected range.
  Future<TenorTrending> getTrendingGifs({
    required TenorTrendingQuery query,
  }) async {
    final response = await _client.get<Json>(
      '/trending',
      queryParameters: query.toJson(),
    );
    return TenorTrending.fromJson(response.data ?? emptyJson);
  }

  ///
  /// Get a json object containing a list of the current trending search terms.
  /// The list is updated Hourly by Tenor’s AI.
  ///
  /// `Best Practices:`
  ///
  /// 1. Use the Locale parameter. As Tenor’s service evolves, locale will be
  ///    used to better tune search results to your users’ specific languages,
  ///    cultures, and social trends. Using Locale will give higher preference
  ///    to the user’s given locale, though it will not limit search results
  ///    to only the provided code and language typed, but gives higher
  ///    preference to the given locale. The default value is en_US.
  ///
  /// 2. Display the results in the order provided by the response object.
  Future<TenorTerms> getTrendingSearchTerms(TenorQuery query) async {
    final response = await _client.get<Json>(
      '/trending_terms',
      queryParameters: query.toJson(),
    );
    return TenorTerms.fromJson(response.data ?? emptyJson);
  }

  ///
  /// Get a json object containing a list of GIF categories associated with the
  /// provided type. Each category will include a corresponding search URL
  /// to be used if the user clicks on the category. The search URL will
  /// include the apikey, anonymous id, and locale that were used on the
  /// original call to the categories endpoint.
  ///
  /// `Supported types:`
  ///
  /// 1. featured (default) - The current featured emotional / reaction based
  ///    GIF categories including a preview GIF for each term.
  ///
  /// 2. emoji - The current featured emoji GIF categories
  ///
  /// 3. trending - The current trending search terms including a
  ///    preview GIF for each term.
  Future<TenorCategories> getCategories(TenorCategoriesQuery query) async {
    final response = await _client.get<Json>(
      '/categories',
      queryParameters: query.toJson(),
    );
    return TenorCategories.fromJson(response.data ?? emptyJson);
  }

  /// Register a user’s sharing of a GIF.
  ///
  /// `Best Practices:`
  ///
  /// 1. Provide the search term. This helps further tune Tenor’s
  ///    Search Engine AI, helping users more easily find the perfect GIF.
  ///
  /// 2. Use the Locale parameter. As Tenor’s service evolves, locale will
  ///    be used to better tune search results to your users’ specific
  ///    languages, cultures, and social trends. The default value is en_US.
  Future<TenorSuccess> registerShareEvent(TenorRegisterShareQuery query) async {
    final response = await _client.get<Json>(
      '/registershare',
      queryParameters: query.toJson(),
    );
    return TenorSuccess.fromJson(response.data ?? emptyJson);
  }

  /// Get the GIF(s) for the corresponding id(s)
  ///
  /// `Best Practices:`
  ///
  /// 1. Use the media_filter parameter to reduce the number of GIF formats
  ///    returned. This can reduce the response object size by 25-75%.
  Future<TenorCollection> getCorrespondingGifs(
    TenorCorrespondingGifsQuery query,
  ) async {
    final response = await _client.get<Json>(
      '/gifs',
      queryParameters: query.toJson(),
    );
    return TenorCollection.fromJson(response.data ?? emptyJson);
  }

  /// Get a randomized list of GIFs for a given search term.
  /// This differs from the search endpoint which returns a rank ordered
  /// list of GIFs for a given search term.
  ///
  /// `Best Practices:`
  ///
  /// 1. Use the Locale parameter. As Tenor’s service evolves, locale will
  ///    be used to better tune search results to your users’ specific
  ///    languages, cultures, and social trends. Using Locale will give
  ///    higher preference to the user’s given locale, though it will not
  ///    limit search results to only the provided code and language typed,
  ///    but gives higher preference to the given locale.
  ///    The default value is en_US.
  ///
  /// 2. Use the ContentFilter parameter to maintain your internal content
  ///    safety ratings for GIFs returned. The default value is off
  ///
  /// 3. Use the media_filter parameter to reduce the number of GIF formats
  ///    returned. This can reduce the response object size by 25-75%.
  ///
  /// 4. Use the ar_range parameter to filter the GIF response list to only
  ///    include aspect ratios that fall within the selected range.
  Future<TenorCollection> getRandomGifs(TenorSearchQuary query) async {
    final response = await _client.get<Json>(
      '/random',
      queryParameters: query.toJson(),
    );
    return TenorCollection.fromJson(response.data ?? emptyJson);
  }

  ///
  /// Get an anonymous ID for a new user. Store the ID in the client’s cache
  /// for use on any additional API calls made by the user, either in this
  /// session or any future sessions. Note: using anonymous ID to personalize
  /// API responses requires custom development. Please see the Custom
  /// APIs section for more detail.
  Future<TenorAnonymousUser> getAnonymousUserId() async {
    final response = await _client.get<Json>('/anonid');
    return TenorAnonymousUser.fromJson(response.data ?? emptyJson);
  }
}
