// ignore_for_file: use_super_parameters

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  NoInternetException([String message = 'No internet connection. Please check your network and try again.'])
      : super(message);
}

class BadRequestException extends ApiException {
  final Map<String, dynamic>? errors;
  BadRequestException({String message = 'Bad request. Invalid input fields.', int? statusCode, this.errors})
      : super(message, statusCode: statusCode);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized. Please login again.'])
      : super(message, statusCode: 401);
}

class ServerException extends ApiException {
  ServerException([String message = 'Server error. Please try again later.'])
      : super(message, statusCode: 500);
}

class TimeoutException extends ApiException {
  TimeoutException([String message = 'Request timed out. Please try again.'])
      : super(message);
}

class UnknownException extends ApiException {
  UnknownException([String message = 'An unexpected error occurred.'])
      : super(message);
}
