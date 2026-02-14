import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import 'package:untitled8/features/auth/data/model/login_response.dart';
import 'package:untitled8/features/profile/data/datasources/update_password_remote_data_source.dart';
import 'package:untitled8/features/profile/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final UpdatePasswordRemoteDataSource _updatePasswordRemoteDataSource;

  ProfileRepositoryImpl(this._updatePasswordRemoteDataSource);

  @override
  Future<Either<Failure, User>> updatePassword(
      Map<String, dynamic> params) async {
    try {
      final result = await _updatePasswordRemoteDataSource.updatePassword(params);
      return Right(result.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, User>> updateProfileInfo(Map<String, dynamic> params) async {
    try {
      // نستخدم نفس الـ RemoteDataSource لأن الـ Endpoint هو نفسه
      final result = await _updatePasswordRemoteDataSource.updatePassword(params);
      return Right(result.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
