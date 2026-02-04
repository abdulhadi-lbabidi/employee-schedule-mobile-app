import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/features/auth/data/datasource/authRemoteDataSourceImpl.dart';
import '../../../../core/unified_api/failures.dart';
import '../model/login_response.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository with HandlingException {
  final AuthRemoteDataSourceImpl remoteDataSource;
  final FlutterSecureStorage secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthRepository({required this.remoteDataSource, required this.secureStorage});

  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  })
  async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.login(email: email, password: password),
    );
  }

  // Future<void> _saveAuthData(LoginResponse response) async {
  //   try {
  //     if (response.token != null && response.token!.isNotEmpty) {
  //       await secureStorage.write(key: _tokenKey, value: response.token);
  //     }
  //     if (response.user != null) {
  //       await secureStorage.write(
  //         key: _userKey,
  //         value: jsonEncode(response.user!.toJson()),
  //       );
  //     }
  //     debugPrint("DEBUG: Auth data written to storage.");
  //   } catch (e) {
  //     debugPrint("DEBUG: Error saving auth data: $e");
  //   }
  // }
  //
  // Future<String?> getToken() async => await secureStorage.read(key: _tokenKey);
  //
  // Future<bool> isTokenPresent() async {
  //   final token = await secureStorage.read(key: _tokenKey);
  //   final exists = token != null && token.isNotEmpty;
  //   debugPrint("DEBUG: isTokenPresent: $exists");
  //   return exists;
  // }
  //
  // Future<bool> isLoggedIn() async {
  //   final token = await getToken();
  //   if (token == null || token.isEmpty) return false;
  //
  //   try {
  //     // التحقق من الصلاحية مع مهلة قصيرة
  //     final isValid = await remoteDataSource
  //         .verifyToken(token)
  //         .timeout(const Duration(seconds: 10));
  //     return isValid;
  //   } catch (e) {
  //     debugPrint("DEBUG: isLoggedIn check failed: $e");
  //     // إذا كان الخطأ هو Timeout أو مشكلة شبكة، نثق بالتوكن المحلي
  //     return true;
  //   }
  // }

  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _userKey);
  }

  Future<Either<Failure, LoginResponse>> getCurrentUser()   async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.getMe(),
    );
  }
}
