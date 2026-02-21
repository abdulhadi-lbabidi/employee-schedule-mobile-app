import 'package:untitled8/core/unified_api/error_handler.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../domain/repositories/loan_repository.dart';
import '../../domain/usecases/add_loan_usecase.dart';
import '../datasources/loan_local_data_source.dart';
import '../datasources/loan_remote_data_source_impl.dart';
import '../models/get_all_loan_response.dart';
import '../models/get_all_loane.dart';
import '../models/loan_model.dart';
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
  DataResponse<GetAllLoane> getAllLoans() async =>
      wrapHandlingException<GetAllLoane>(
        tryCall: () async {
          final response = await remoteDataSource.getAllLoans();

          if (response.data != null) {

            await localDataSource.cacheallLoans(response.data!);
          }

          return response;
        },
        otherCall: () async {
          final cached = await localDataSource.getCachedallLoans();

          return GetAllLoane(data: cached);
        },
      );

  @override
  DataResponse<GetAllLoansResponse> getEmployeeLoans(int employeeId) async =>
      wrapHandlingException(
        tryCall: () => remoteDataSource.getEmployeeLoans(employeeId),
        otherCall: () async { // Added async back
          final cached = localDataSource.getCachedEmployeeLoans(employeeId);
          return GetAllLoansResponse(data: cached);
        },
      );

  @override
  DataResponse<void> addLoan(AddLoanParams loan) async {
    return wrapHandlingException(tryCall: () => remoteDataSource.addLoan(loan));
  }

  @override
  DataResponse<void> approveLoan(int loanId) async {
    return wrapHandlingException(tryCall: () => remoteDataSource.approveLoan(loanId));
  }

  @override
  DataResponse<void> rejectLoan(int loanId) async {
    return wrapHandlingException(tryCall: () => remoteDataSource.rejectLoan(loanId));
  }

  @override
  DataResponse<void> payLoan(int loanId, double amount) async {
    return wrapHandlingException(tryCall: () => remoteDataSource.payLoan(loanId, amount));
  }

  @override
  @Deprecated('Use approveLoan or rejectLoan')
  DataResponse<void> updateLoanStatus(int loanId, int amount) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.approveLoan(loanId),
    );
  }

  @override
  @Deprecated('Use payLoan')
  DataResponse<void> recordPayment(int loanId, double amount) async {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.payLoan(loanId, amount),
    );
  }
}
