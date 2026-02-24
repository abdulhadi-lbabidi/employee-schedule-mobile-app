
import 'notification_model.dart';

GetAllNotificationsResponse getAllNotificationsResponseFromJson( str) => GetAllNotificationsResponse.fromJson(str);


class GetAllNotificationsResponse {
  final List<NotificationModel>? data;

  GetAllNotificationsResponse({
    this.data,
  });

  GetAllNotificationsResponse copyWith({
    List<NotificationModel>? data,
  }) =>
      GetAllNotificationsResponse(
        data: data ?? this.data,
      );

  factory GetAllNotificationsResponse.fromJson(Map<String, dynamic> json) => GetAllNotificationsResponse(
    data: json["data"] == null ? [] : List<NotificationModel>.from(json["data"]!.map((x) => NotificationModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
