import '../../domain/entities/loan_entity.dart';
import '../../domain/repositories/loan_repository.dart';
import '../datasources/loan_remote_data_source.dart';
import '../datasources/loan_local_data_source.dart';
import '../models/loan_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
@LazySingleton(as: LoanRepository)
class LoanRepositoryImpl implements LoanRepository {
  final LoanRemoteDataSource remoteDataSource;
  final LoanLocalDataSource localDataSource;
  final Connectivity connectivity;

  LoanRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<List<LoanEntity>> getAllLoans() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final remoteLoans = await remoteDataSource.getAllLoans();
        await localDataSource.cacheLoans(remoteLoans);
        return remoteLoans;
      } catch (_) {
        return localDataSource.getCachedLoans();
      }
    } else {
      return localDataSource.getCachedLoans();
    }
  }

  @override
  Future<List<LoanEntity>> getEmployeeLoans(String employeeId) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final remoteLoans = await remoteDataSource.getEmployeeLoans(employeeId);
        // تحديث الكاش المحلي بالسلف الخاصة بهذا الموظف (بشكل جزئي أو كلي حسب التصميم)
        // هنا سنفترض أننا نريد تحديث ما لدينا
        return remoteLoans;
      } catch (_) {
        return localDataSource.getCachedEmployeeLoans(employeeId);
      }
    } else {
      return localDataSource.getCachedEmployeeLoans(employeeId);
    }
  }

  @override
  Future<void> addLoan(LoanEntity loan) async {
    final connectivityResult = await connectivity.checkConnectivity();
    final loanModel = LoanModel.fromEntity(loan);
    
    // في نظام متكامل، قد نرغب في إضافة السلفة محلياً أولاً ثم مزامنتها
    if (connectivityResult != ConnectivityResult.none) {
      await remoteDataSource.addLoan(loanModel);
    }
    // تحديث الكاش المحلي
    final loans = localDataSource.getCachedLoans();
    loans.add(loanModel);
    await localDataSource.cacheLoans(loans);
  }

  @override
  Future<void> updateLoanStatus(String loanId, LoanStatus status) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await remoteDataSource.updateLoanStatus(loanId, status);
    }
    // تحديث محلي
    final loans = localDataSource.getCachedLoans();
    final index = loans.indexWhere((l) => l.id == loanId);
    if (index != -1) {
      loans[index] = LoanModel.fromEntity(loans[index].copyWith(status: status));
      await localDataSource.cacheLoans(loans);
    }
  }

  @override
  Future<void> recordPayment(String loanId, double amount) async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await remoteDataSource.recordPayment(loanId, amount);
    }
    // تحديث محلي
    final loans = localDataSource.getCachedLoans();
    final index = loans.indexWhere((l) => l.id == loanId);
    if (index != -1) {
      final currentPaid = loans[index].paidAmount;
      final newPaid = currentPaid + amount;
      LoanStatus newStatus = loans[index].status;
      if (newPaid >= loans[index].amount) {
        newStatus = LoanStatus.fullyPaid;
      } else if (newPaid > 0) {
        newStatus = LoanStatus.partiallyPaid;
      }
      loans[index] = LoanModel.fromEntity(loans[index].copyWith(
        paidAmount: newPaid,
        status: newStatus,
      ));
      await localDataSource.cacheLoans(loans);
    }
  }
}
