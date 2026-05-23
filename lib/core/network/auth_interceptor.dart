import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    // Retrieve saved token and inject it into the headers
    final token = await SecureStorageService.instance.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      debugPrint('--> HTTP REQUEST');
      debugPrint('${options.method.toUpperCase()} ${options.uri}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
      debugPrint('--------------------------------------------------');
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- HTTP RESPONSE');
      debugPrint('${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('Headers: ${response.headers.map}');
      debugPrint('Data: ${response.data}');
      debugPrint('--------------------------------------------------');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- HTTP ERROR');
      debugPrint('${err.response?.statusCode ?? "NO_STATUS_CODE"} ${err.requestOptions.uri}');
      debugPrint('Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('Response Data: ${err.response?.data}');
      }
      debugPrint('--------------------------------------------------');
    }
    return handler.next(err);
  }
}
