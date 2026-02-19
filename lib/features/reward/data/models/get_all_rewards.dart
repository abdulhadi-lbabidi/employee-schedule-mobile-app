// To parse this JSON data, do
//
//     final getAllRewards = getAllRewardsFromJson(jsonString);

import 'dart:convert';

GetAllRewards getAllRewardsFromJson(String str) => GetAllRewards.fromJson(json.decode(str));

String getAllRewardsToJson(GetAllRewards data) => json.encode(data.toJson());

class GetAllRewards {
  final List<Rewards>? data;

  GetAllRewards({
    this.data,
  });

  GetAllRewards copyWith({
    List<Rewards>? data,
  }) =>
      GetAllRewards(
        data: data ?? this.data,
      );

  factory GetAllRewards.fromJson(Map<String, dynamic> json) => GetAllRewards(
    data: json["data"] == null ? [] : List<Rewards>.from(json["data"]!.map((x) => Rewards.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Rewards {
  final int? id;
  final String? amount;
  final String? reason;
  final DateTime? dateIssued;
  final dynamic adminName;
  final DateTime? createdAt;

  Rewards({
    this.id,
    this.amount,
    this.reason,
    this.dateIssued,
    this.adminName,
    this.createdAt,
  });

  Rewards copyWith({
    int? id,
    String? amount,
    String? reason,
    DateTime? dateIssued,
    dynamic adminName,
    DateTime? createdAt,
  }) =>
      Rewards(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        reason: reason ?? this.reason,
        dateIssued: dateIssued ?? this.dateIssued,
        adminName: adminName ?? this.adminName,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Rewards.fromJson(Map<String, dynamic> json) => Rewards(
    id: json["id"],
    amount: json["amount"],
    reason: json["reason"],
    dateIssued: json["date_issued"] == null ? null : DateTime.parse(json["date_issued"]),
    adminName: json["admin_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "reason": reason,
    "date_issued": "${dateIssued!.year.toString().padLeft(4, '0')}-${dateIssued!.month.toString().padLeft(2, '0')}-${dateIssued!.day.toString().padLeft(2, '0')}",
    "admin_name": adminName,
    "created_at": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
  };
}
