import 'package:dio/dio.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/http/interceptors/key_interceptor.dart';
import 'package:gif_picker/src/http/interceptors/logging_interceptor.dart';
import 'package:gif_picker/src/http/key_manager.dart';

const _defaultBaseURL = 'https://g.tenor.com/v1';

///
class GifPickerClientOption {
  /// Instantiates a new [GifPickerClientOption]
  const GifPickerClientOption({
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

///
class GifPickerClient {
  /// [GifPickerClient] constructor
  GifPickerClient({
    GifPickerClientOption? options,
    KeyManager keyManager = const KeyManager(),
  })  : _options = options ?? const GifPickerClientOption(),
        httpClient = Dio() {
    httpClient
      ..options.baseUrl = _options.baseUrl
      ..options.receiveTimeout = _options.receiveTimeout
      ..options.connectTimeout = _options.connectTimeout
      ..interceptors.addAll([
        KeyInterceptor(keyManager),
        // if (logger != null && logger.level != Level.OFF)
        LoggingInterceptor(
          requestHeader: true,
          // logPrint: (step, message) {
          //   switch (step) {
          //     case InterceptStep.request:
          //       return logger.info(message);
          //     case InterceptStep.response:
          //       return logger.info(message);
          //     case InterceptStep.error:
          //       return logger.severe(message);
          //   }
          // },
        ),
      ]);
  }

  /// Your project ClientOptions
  final GifPickerClientOption _options;

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
    } on DioException catch (error) {
      throw TenorNetworkError.fromDioError(error);
    }
  }

  //
}
