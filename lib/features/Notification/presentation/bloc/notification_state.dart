import 'package:untitled8/core/data_state_model.dart';

import '../../data/model/notification_model.dart';

class NotificationState {
  final DataStateModel<void> sendNotificationData;
  final DataStateModel<void> checkInData;
  final DataStateModel<void> checkOutData;
  final DataStateModel<List<NotificationModel>?> getNotificationsData;

  NotificationState({
    this.sendNotificationData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.checkInData = const DataStateModel.setDefultValue(defultValue: null),
    this.checkOutData = const DataStateModel.setDefultValue(defultValue: null),
    this.getNotificationsData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
  });

  NotificationState copyWith({
    DataStateModel<void>? sendNotificationData,
    DataStateModel<void>? checkInData,
    DataStateModel<void>? checkOutData,
    DataStateModel<List<NotificationModel>?>? getNotificationsData,
  }) {
    return NotificationState(
      sendNotificationData: sendNotificationData ?? this.sendNotificationData,
      checkInData: checkInData ?? this.checkInData,
      checkOutData: checkOutData ?? this.checkOutData,
      getNotificationsData: getNotificationsData ?? this.getNotificationsData,
    );
  }
}

//
// class NotificationInitial extends NotificationState {}
//
// class NotificationLoading extends NotificationState {}
//
// class NotificationLoaded extends NotificationState {
//   final List<NotificationModel> notifications; // تم التغيير من NotificationEntity إلى NotificationModel
//   NotificationLoaded(this.notifications);
// }
//
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
