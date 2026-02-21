import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../domain/usecases/add_loan_usecase.dart';
import '../models/get_all_loan_response.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoanRemoteDataSourceImpl with HandlingApiManager {
  final BaseApi _baseApi;

  LoanRemoteDataSourceImpl({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<GetAllLoansResponse> getAllLoans() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.adminLoans()),
      jsonConvert: getAllLoansResponseFromJson
    );
  }

  Future<GetAllLoansResponse> getEmployeeLoans(int employeeId) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.employeeLoans(employeeId)),
      jsonConvert: getAllLoansResponseFromJson
    );
  }

  Future<void> addLoan(AddLoanParams loan) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(ApiVariables.postLoans(), data: loan.getBody()),
      jsonConvert: (_) {},
    );
  }

  Future<void> approveLoan(int loanId) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(ApiVariables.postApproveLoans(loanId)),
      jsonConvert: (_) {},
    );
  }

  Future<void> rejectLoan(int loanId) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(ApiVariables.postRejectLoans(loanId)),
      jsonConvert: (_) {},
    );
  }

  Future<void> payLoan(int loanId, double amount) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(ApiVariables.postPayLoans(loanId), data: {'amount': amount}),
      jsonConvert: (_) {},
    );
  }

//   @Deprecated('Use approveLoan or rejectLoan')
//   Future<void> updateLoanStatus(int loanId, int amount) async {
//     return wrapHandlingApi(
//       tryCall: () => _baseApi.put(ApiVariables.loanStatus(loanId), data: {'amount': amount}),
//       jsonConvert: (_) {},
//     );
//   }
//
//   @Deprecated('Use payLoan')
//   Future<void> recordPayment(int loanId, double amount) async {
//     return wrapHandlingApi(
//       tryCall: () => _baseApi.post(ApiVariables.loanPayments(loanId), data: {'amount': amount}),
//       jsonConvert: (_) {},
//     );
//   }
 }
