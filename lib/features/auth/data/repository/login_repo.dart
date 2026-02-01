import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/unified_api/failures.dart';
import '../../../../core/unified_api/handling_exception_manager.dart';
import '../datasource/auth_remote_data_source.dart';
import '../model/login_response.dart';

class AuthRepository with HandlingExceptionManager {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthRepository({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    return wrapHandling(tryCall: () async {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );
      
      if (response.token == null || response.token!.isEmpty) {
        throw Exception("Server returned success but token is empty.");
      }
      
      // تأكيد الحفظ وانتظاره
      await _saveAuthData(response);
      
      // تحقق إضافي بعد الحفظ مباشرة للـ Debug
      final savedToken = await getToken();
      debugPrint("DEBUG: Token saved and verified: ${savedToken != null}");
      
      return response;
    });
  }

  Future<void> _saveAuthData(LoginResponse response) async {
    try {
      if (response.token != null && response.token!.isNotEmpty) {
        await secureStorage.write(key: _tokenKey, value: response.token);
      }
      if (response.user != null) {
        await secureStorage.write(
          key: _userKey,
          value: jsonEncode(response.user!.toJson()),
        );
      }
      debugPrint("DEBUG: Auth data written to storage.");
    } catch (e) {
      debugPrint("DEBUG: Error saving auth data: $e");
    }
  }

  Future<String?> getToken() async => await secureStorage.read(key: _tokenKey);
  
  Future<bool> isTokenPresent() async {
    final token = await secureStorage.read(key: _tokenKey);
    final exists = token != null && token.isNotEmpty;
    debugPrint("DEBUG: isTokenPresent: $exists");
    return exists;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    
    try {
      // التحقق من الصلاحية مع مهلة قصيرة
      final isValid = await remoteDataSource.verifyToken(token).timeout(const Duration(seconds: 10));
      return isValid;
    } catch (e) {
      debugPrint("DEBUG: isLoggedIn check failed: $e");
      // إذا كان الخطأ هو Timeout أو مشكلة شبكة، نثق بالتوكن المحلي
      return true; 
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _userKey);
  }

  Future<User?> getCurrentUser() async {
    final jsonString = await secureStorage.read(key: _userKey);
    if (jsonString == null) return null;
    try {
      return User.fromJson(jsonDecode(jsonString));
    } catch (_) {
      return null;
    }
  }
}
