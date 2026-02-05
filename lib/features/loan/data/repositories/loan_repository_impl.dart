import 'package:untitled8/core/unified_api/error_handler.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../domain/repositories/loan_repository.dart';
import '../../domain/usecases/add_loan_usecase.dart';
import '../datasources/loan_local_data_source.dart';
import '../datasources/loan_remote_data_source_impl.dart';
import '../models/get_all_loan_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoanRepository)
class LoanRepositoryImpl with HandlingException implements LoanRepository {
  final LoanRemoteDataSourceImpl remoteDataSource;
  final LoanLocalDataSource localDataSource;

  LoanRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  DataResponse<GetAllLoansResponse> getAllLoans() async =>
      wrapHandlingException(
        tryCall: () => remoteDataSource.getAllLoans(),
        otherCall: () => localDataSource.getCachedLoans(),
      );

  @override
  DataResponse<GetAllLoansResponse> getEmployeeLoans(int employeeId) async =>
      wrapHandlingException(
        tryCall: () => remoteDataSource.getEmployeeLoans(employeeId),
        otherCall: () => localDataSource.getCachedEmployeeLoans(employeeId),
      );

  @override
  DataResponse<void> addLoan(AddLoanParams loan) async {
    return wrapHandlingException(tryCall: () => remoteDataSource.addLoan(loan));
  }

  @override
  DataResponse<void> updateLoanStatus(int loanId, int amount) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.updateLoanStatus( loanId,  amount),

    );
  }

  @override
  DataResponse<void> recordPayment(int loanId, double amount) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.recordPayment( loanId,  amount),

    );
  }
}
