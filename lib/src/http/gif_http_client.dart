import 'package:dio/dio.dart';
import 'package:gif_picker/src/http/interceptors/key_interceptor.dart';
import 'package:gif_picker/src/http/interceptors/logging_interceptor.dart';
import 'package:gif_picker/src/http/key_manager.dart';
import 'package:logging/logging.dart';

const _defaultBaseURL = 'https://g.tenor.com/v1';

///
class GifHttpClient {
  /// [GifHttpClient] constructor
  GifHttpClient({
    GifHttpClientOption? options,
    KeyManager keyManager = const KeyManager(),
    Logger? logger,
  })  : _options = options ?? const GifHttpClientOption(),
        httpClient = Dio() {
    httpClient
      ..options.baseUrl = _options.baseUrl
      ..options.receiveTimeout = _options.receiveTimeout.inMilliseconds
      ..options.connectTimeout = _options.connectTimeout.inMilliseconds
      ..interceptors.addAll([
        KeyInterceptor(keyManager),
        if (logger != null && logger.level != Level.OFF)
          LoggingInterceptor(
            requestHeader: true,
            logPrint: (step, message) {
              switch (step) {
                case InterceptStep.request:
                  return logger.info(message);
                case InterceptStep.response:
                  return logger.info(message);
                case InterceptStep.error:
                  return logger.severe(message);
              }
            },
          ),
      ]);
  }

  /// Your project ClientOptions
  final GifHttpClientOption _options;

  /// [Dio] httpClient
  /// It's been chosen because it's easy to use
  /// and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  final Dio httpClient;

  /// Handy method to make http GET request with error parsing.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (_) {
      // Parse error here
      rethrow;
    }
  }

  /// Handy method to make http POST request with error parsing.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    Map<String, Object?>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpClient.post<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (_) {
      // Parse error
      rethrow;
    }
  }

  //
}

///
class GifHttpClientOption {
  /// Instantiates a new [GifHttpClientOption]
  const GifHttpClientOption({
    this.baseUrl = _defaultBaseURL,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  /// base url to use with client. Default is [https://g.tenor.com/v1]
  final String baseUrl;

  /// connect timeout, default to 30s
  final Duration connectTimeout;

  /// received timeout, default to 30s
  final Duration receiveTimeout;
}
