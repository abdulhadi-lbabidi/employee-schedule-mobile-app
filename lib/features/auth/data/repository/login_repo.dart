import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/features/auth/data/datasource/authRemoteDataSourceImpl.dart';
import '../../../../core/unified_api/failures.dart';
import '../model/login_response.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository with HandlingException {
  final AuthRemoteDataSourceImpl remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepository({required this.remoteDataSource, required this.secureStorage});

  Future<Either<Failure, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.login(email: email, password: password),
    );
  }

  DataResponse<void> logout() async {
    return wrapHandlingException(tryCall: () => remoteDataSource.logOut());
  }

  Future<Either<Failure, LoginResponse>> getCurrentUser() async {
    return wrapHandlingException(tryCall: () => remoteDataSource.getMe());
  }

  DataResponse<LoginResponse> updateProfile(File image) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.updateProfile(image: image),
    );
  }
}
