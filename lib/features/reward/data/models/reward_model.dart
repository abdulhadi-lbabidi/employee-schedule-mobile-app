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
    // استخراج الاسم من هيكلية الـ JSON المعقدة التي أرسلتها
    String name = "Unknown";
    if (json['employee'] != null && json['employee']['user'] != null) {
      name = json['employee']['user']['full_name'] ?? "Unknown";
    }

    return RewardModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String,
      dateIssued: DateTime.parse(json['date_issued']),
      employeeName: name, // استخدام الاسم المستخرج
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
