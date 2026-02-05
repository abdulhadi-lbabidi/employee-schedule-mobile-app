import '../../../../common/helper/src/typedef.dart';
import '../../data/models/get_all_loan_response.dart';
import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class GetAllLoansUseCase {
  final LoanRepository repository;

  GetAllLoansUseCase(this.repository);

  DataResponse<GetAllLoansResponse> call() async {
    return await repository.getAllLoans();
  }
}
