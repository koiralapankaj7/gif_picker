import 'package:dio/dio.dart';
import 'package:gif_picker/src/http/key_manager.dart';

/// Interceptor that injects the api key in the request params
class KeyInterceptor extends Interceptor {
  ///
  KeyInterceptor(this.keyManager);

  ///
  final KeyManager keyManager;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.queryParameters.addAll(<String, dynamic>{'key': keyManager.key});
    handler.next(options);
  }
}
