import 'package:dio/dio.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../domain/entities/loan_entity.dart';
import '../models/loan_model.dart';
import 'loan_remote_data_source.dart';

class LoanRemoteDataSourceImpl implements LoanRemoteDataSource {
  final Dio dio;
  final ApiVariables apiVariables = ApiVariables();

  LoanRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LoanModel>> getAllLoans() async {
    final response = await dio.getUri(apiVariables.adminLoans());
    final List list = response.data['data'];
    return list.map((e) => LoanModel.fromJson(e)).toList();
  }

  @override
  Future<List<LoanModel>> getEmployeeLoans(String employeeId) async {
    final response = await dio.getUri(apiVariables.employeeLoans(employeeId));
    final List list = response.data['data'];
    return list.map((e) => LoanModel.fromJson(e)).toList();
  }

  @override
  Future<void> addLoan(LoanModel loan) async {
    await dio.postUri(
      apiVariables.adminLoans(),
      data: loan.toJson(),
    );
  }

  @override
  Future<void> updateLoanStatus(String loanId, LoanStatus status) async {
    await dio.putUri(
      apiVariables.loanStatus(loanId),
      data: {'status': status.toString().split('.').last},
    );
  }

  @override
  Future<void> recordPayment(String loanId, double amount) async {
    await dio.postUri(
      apiVariables.loanPayments(loanId),
      data: {'amount': amount},
    );
  }
}
