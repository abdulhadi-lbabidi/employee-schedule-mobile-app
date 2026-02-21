import '../../domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required super.id,
    required super.amount,
    required super.reason,
    required super.dateIssued,
    required super.employeeName,
    super.adminName,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    String name = "Unknown";
    if (json['employee'] != null && json['employee']['user'] != null) {
      name = json['employee']['user']['full_name'] ?? "Unknown";
    }

    // ✅ حل مشكلة amount
    final amountValue = json['amount'];
    final double parsedAmount = amountValue is num
        ? amountValue.toDouble()
        : double.tryParse(amountValue.toString()) ?? 0.0;

    return RewardModel(
      id: json['id'] as int,
      amount: parsedAmount,
      reason: json['reason'] as String,
      dateIssued: DateTime.parse(json['date_issued']),
      employeeName: name,
      adminName: json['admin_name'] as String?,
    );
  }
}

class RewardResponse {
  final List<RewardModel> data;

  RewardResponse({required this.data});

  factory RewardResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return RewardResponse(
        data: (json['data'] as List).map((e) => RewardModel.fromJson(e)).toList(),
      );
    } else if (json['data'] != null) {
      return RewardResponse(
        data: [RewardModel.fromJson(json['data'])],
      );
    } else {
      return RewardResponse(data: []);
    }
  }
}
