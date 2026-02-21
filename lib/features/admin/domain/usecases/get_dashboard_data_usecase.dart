import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import '../../data/models/employee model/employee_model.dart';
import '../../data/models/get_dashboard_data.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetDashboardDataUsecase {
  final AdminRepository adminRepository;

  GetDashboardDataUsecase(this.adminRepository);

  DataResponse<GetDashboardData> call() {
    return adminRepository.getDashbordData();
  }
}