import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetEmployeeLoansUseCase {
  final LoanRepository repository;

  GetEmployeeLoansUseCase(this.repository);

  Future<List<LoanEntity>> call(String employeeId) async {
    return await repository.getEmployeeLoans(employeeId);
  }
}
