import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._privateConstructor();

  static final SecureStorageService instance = SecureStorageService._privateConstructor();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
