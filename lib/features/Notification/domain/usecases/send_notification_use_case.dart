import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/use_case.dart';

import '../../../../common/helper/src/typedef.dart';
import '../repositories/notification_repository.dart';

@injectable
class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  DataResponse<void> call(SendNotificationParams params) async {
    return await repository.sendNotification(params.getBody());
  }
}

class SendNotificationParams with Params {
  final String title;
  final String body;
  final int? targetWorkshop;
  final int? targetEmployeeId;

  SendNotificationParams({
    required this.title,
    required this.body,
    this.targetWorkshop,
    this.targetEmployeeId,
  });

  @override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      "title": title,
      "body": body,
      "user_id": targetEmployeeId,
      "workshop_id": targetWorkshop,
    }..removeWhere(
      (key, value) => value == null || value == '' || value == 'null',
    );
  }
}
