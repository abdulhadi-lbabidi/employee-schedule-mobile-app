import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/repositories/reward_repository.dart';
import '../datasources/reward_remote_data_source.dart'; // This was causing the undefined class error
import '../models/get_all_rewards.dart';
import '../models/reward_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RewardRepository)
class RewardRepositoryImpl with HandlingException implements RewardRepository {
  final RewardRemoteDataSource remoteDataSource;

  RewardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RewardEntity>>> getEmployeeRewards(int employeeId) async {
    return wrapHandlingException(
      tryCall: () async {
        final response = await remoteDataSource.getEmployeeRewards(employeeId);
        return response.data;
      },
    );
  }

  @override
  @override
  Future<Either<Failure, List<Rewards>>> getAdminRewards() async { // تعديل النوع هنا أيضاً
    return wrapHandlingException(
      tryCall: () async {
        // response هنا هو كائن من نوع GetAllRewards
        final response = await remoteDataSource.getAdminRewards();

        // الوصول لبيانات القائمة الفعلية (List<Rewards>) داخل الكائن
        return response.data ?? [];
      },
    );
  }

  @override
  Future<Either<Failure, void>> issueReward({
    required int employeeId,
    required int adminId,
    required double amount,
    required String reason,
    required String  date,
  }) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.issueReward(
        employeeId: employeeId,
        adminId: adminId,
        amount: amount,
        reason: reason,
        dateissued: date,
      ),
    );
  }
}
