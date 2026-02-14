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

  Future<Either<Failure, void>> logout() async {
     try {
      await remoteDataSource.logOut();
      // 🔹 عند تسجيل الخروج، يجب أيضًا حذف رمز FCM من الخادم
      // يتم ذلك في `deleteFCMToken` في `LoginCubit` أو `ProfileBloc`
      return const Right(());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<Either<Failure, LoginResponse>> getCurrentUser() async {
    return wrapHandlingException(tryCall: () => remoteDataSource.getMe());
  }

  Future<Either<Failure, LoginResponse>> updateProfile(File image) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.updateProfile(image: image),
    );
  }

  // 🔹 إضافة دوال تحديث وحذف رمز FCM
  Future<Either<Failure, void>> updateFCMToken(String? token) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.updateFCMToken(token: token),
    );
  }

  Future<Either<Failure, void>> deleteFCMToken() async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.deleteFCMToken(),
    );
  }
}
