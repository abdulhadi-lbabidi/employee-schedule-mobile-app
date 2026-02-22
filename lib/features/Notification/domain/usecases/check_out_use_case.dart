import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../repositories/notification_repository.dart';
import 'check_in_use_case.dart';

@injectable
class CheckOutUseCase {
  final NotificationRepository repository;

  CheckOutUseCase(this.repository);

  DataResponse<void> call(CheckInParams params) async {
    return await repository.checkOutWorkshop(params.getBody());
  }
}
