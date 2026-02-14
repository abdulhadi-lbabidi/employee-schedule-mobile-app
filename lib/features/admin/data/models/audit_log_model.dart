
class AuditLogModel {
  final String id;
  final String adminName;
  final String actionType;
  final String targetName;
  final String details;
  final DateTime timestamp;

  AuditLogModel({
    required this.id,
    required this.adminName,
    required this.actionType,
    required this.targetName,
    required this.details,
    required this.timestamp,
  });

  /// 🔹 copyWith
  AuditLogModel copyWith({
    String? id,
    String? adminName,
    String? actionType,
    String? targetName,
    String? details,
    DateTime? timestamp,
  }) {
    return AuditLogModel(
      id: id ?? this.id,
      adminName: adminName ?? this.adminName,
      actionType: actionType ?? this.actionType,
      targetName: targetName ?? this.targetName,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// 🔹 toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "adminName": adminName,
      "actionType": actionType,
      "targetName": targetName,
      "details": details,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  /// 🔹 fromJson
  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json["id"],
      adminName: json["adminName"],
      actionType: json["actionType"],
      targetName: json["targetName"],
      details: json["details"],
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }
}


