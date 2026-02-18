import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import '../datasource/fcm_remote_data_source.dart';
import '../../domain/repositories/fcm_repository.dart';

@LazySingleton(as: FcmRepository)
class FcmRepositoryImpl implements FcmRepository {
  final FcmRemoteDataSource remoteDataSource;

  FcmRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> updateFcmToken(String token) async {
    try {
      await remoteDataSource.updateFcmToken(token);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
