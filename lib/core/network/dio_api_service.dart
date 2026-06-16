import 'package:dio/dio.dart';
import 'api_exceptions.dart';
import 'api_service.dart';
import 'auth_interceptor.dart';
import 'network_info.dart';

class DioApiService implements ApiService {
  final Dio _dio;
  final NetworkInfo _networkInfo = NetworkInfo();

  DioApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://kingmobiles.com.pk/api',
              // baseUrl: 'http://172.16.16.82:8000/api',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          ) {
    _dio.interceptors.add(AuthInterceptor());
  }

  Future<void> _checkConnectivity() async {
    if (!await _networkInfo.isConnected) {
      throw NoInternetException();
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return TimeoutException(
        'Network connection timeout. Please check your signal and try again.',
      );
    }

    final response = e.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;
      String? errorMessage;

      if (data is Map<String, dynamic>) {
        errorMessage = data['message'] as String?;
      }

      switch (statusCode) {
        case 400:
          return BadRequestException(
            message:
                errorMessage ?? 'Invalid input data. Please check your inputs.',
            statusCode: statusCode,
            errors: data is Map<String, dynamic>
                ? data['errors'] as Map<String, dynamic>?
                : null,
          );
        case 401:
          return UnauthorizedException(
            errorMessage ?? 'Unauthorized. Session expired or token invalid.',
          );
        case 403:
          return ApiException(
            errorMessage ?? 'Forbidden access.',
            statusCode: statusCode,
          );
        case 404:
          return ApiException(
            errorMessage ?? 'Requested resource not found.',
            statusCode: statusCode,
          );
        case 500:
        case 502:
        case 503:
          return ServerException(
            errorMessage ?? 'A server error occurred. Please try again later.',
          );
        default:
          return ApiException(
            errorMessage ?? 'An error occurred during communication.',
            statusCode: statusCode,
          );
      }
    }

    if (e.type == DioExceptionType.connectionError) {
      return NoInternetException(
        'Cannot reach server. Please check your internet connection.',
      );
    }

    return UnknownException(
      e.message ?? 'An unexpected network error occurred.',
    );
  }

  String _formatPhone(String phone) {
    final cleanPhone = phone.trim();
    if (cleanPhone.isEmpty) return cleanPhone;
    return cleanPhone.startsWith('0') ? cleanPhone : '0$cleanPhone';
  }

  @override
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    await _checkConnectivity();
    try {
      final response = await _dio.post(
        '/auth/send-otp',
        data: {'phone': _formatPhone(phone)},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    await _checkConnectivity();
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: {'phone': _formatPhone(phone), 'otp': otp},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> setPin(String pin) async {
    await _checkConnectivity();
    try {
      final response = await _dio.post('/auth/set-pin', data: {'pin': pin});
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> login(String phone, String pin) async {
    await _checkConnectivity();
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'phone': _formatPhone(phone), 'pin': pin},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getProducts([String? search]) async {
    await _checkConnectivity();
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: search != null && search.isNotEmpty ? {'search': search} : null,
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getProductDetails(int id) async {
    await _checkConnectivity();
    try {
      final response = await _dio.get('/products/$id');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getBranches() async {
    await _checkConnectivity();
    try {
      final response = await _dio.get('/branches');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> uploadMultipleFiles(
    List<String> filePaths,
    String folder,
  ) async {
    await _checkConnectivity();
    try {
      final List<MultipartFile> multipartFiles = [];
      for (final path in filePaths) {
        multipartFiles.add(
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        );
      }

      final FormData formData = FormData.fromMap({
        'files[]': multipartFiles,
        'folder': folder,
      });

      final response = await _dio.post('/upload-multiple', data: formData);

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    await _checkConnectivity();
    try {
      final response = await _dio.post('/orders', data: orderData);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> logout() async {
    await _checkConnectivity();
    try {
      final response = await _dio.post('/auth/logout');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getSliders() async {
    await _checkConnectivity();
    try {
      final response = await _dio.get('/website-sliders');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    await _checkConnectivity();
    try {
      final response = await _dio.get('/auth/profile');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> uploadSingleFile(
    String filePath,
    String folder,
  ) async {
    await _checkConnectivity();
    try {
      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'folder': folder,
      });
      final response = await _dio.post('/upload', data: formData);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    String name,
    String? imagePath,
  ) async {
    await _checkConnectivity();
    try {
      final Map<String, dynamic> dataMap = {'name': name};
      if (imagePath != null) {
        dataMap['image_path'] = imagePath;
      }
      final FormData formData = FormData.fromMap(dataMap);
      final response = await _dio.post('/auth/profile', data: formData);
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw UnknownException('Unexpected response format from server.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw UnknownException(e.toString());
    }
  }
}