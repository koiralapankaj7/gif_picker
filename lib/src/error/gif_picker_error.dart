import 'package:dio/dio.dart';
import 'package:gif_picker/gif_picker.dart';

///
class GifPickerError implements Exception {
  ///
  const GifPickerError(
    this.message,
  );

  /// Error message
  final String message;

  @override
  String toString() => 'GifPickerError(message: $message)';
}

///
class TenorNetworkError extends GifPickerError {
  ///
  TenorNetworkError({
    required String message,
    required this.code,
    this.statusCode,
    this.data,
  }) : super(message);

  ///
  factory TenorNetworkError.fromDioError(DioError error) {
    final response = error.response;
    TenorErrorResponse? errorResponse;
    final data = response?.data as Json?;

    if (data != null) {
      errorResponse = TenorErrorResponse.fromJson(data);
    }
    return TenorNetworkError(
      code: errorResponse?.code ?? -1,
      message: errorResponse?.error ?? response?.statusMessage ?? error.message,
      statusCode: response?.statusCode,
      data: errorResponse,
    ).._stackTrace = error.stackTrace;
  }

  /// Error code
  final int code;

  /// HTTP status code
  final int? statusCode;

  /// Tenor error response
  final TenorErrorResponse? data;

  ///
  StackTrace? _stackTrace;

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'StreamChatNetworkError($params)';

    if (printStackTrace && _stackTrace != null) {
      msg += '\n$_stackTrace';
    }
    return msg;
  }
}
