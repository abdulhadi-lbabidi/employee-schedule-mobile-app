import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/use_case.dart';

import '../../../../common/helper/src/typedef.dart';
import '../repositories/notification_repository.dart';

@injectable
class CheckInUseCase {
  final NotificationRepository repository;
  CheckInUseCase(this.repository);

  DataResponse<void> call(CheckInParams params) async {
    return await repository.checkInWorkshop(params.getBody());
  }
}


class CheckInParams with Params{

  final int userId;
  final int workshopId;

  CheckInParams({required this.userId, required this.workshopId});


  @override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      "user_id":userId,
      "workshop_id":workshopId
    };
  }

}