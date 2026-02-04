import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetAllLoansUseCase {
  final LoanRepository repository;

  GetAllLoansUseCase(this.repository);

  Future<List<LoanEntity>> call() async {
    return await repository.getAllLoans();
  }
}
