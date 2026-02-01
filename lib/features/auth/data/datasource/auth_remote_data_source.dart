// lib/features/auth/data/datasource/auth_remote_data_source.dart

import '../model/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login({
    required String email,
    required String password,
  });

  Future<bool> verifyToken(String token);

  Future<LoginResponse> register({
    required String username,
    required String password,
    required String email,
    required String fullName,
    required String role,
  });
}
