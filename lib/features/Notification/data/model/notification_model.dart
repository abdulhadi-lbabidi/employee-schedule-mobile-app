
class NotificationModel {
  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final Data? data;
  final dynamic readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    Data? data,
    dynamic readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        body: body ?? this.body,
        data: data ?? this.data,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    body: json["body"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    readAt: json["read_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "body": body,
    "data": data?.toJson(),
    "read_at": readAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Data {
  final String? route;
  final String? type;

  Data({
    this.route,
    this.type,
  });

  Data copyWith({
    String? route,
    String? type,
  }) =>
      Data(
        route: route ?? this.route,
        type: type ?? this.type,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    route: json["route"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "route": route,
    "type": type,
  };
}
