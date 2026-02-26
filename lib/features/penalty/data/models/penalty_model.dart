import '../../domain/entities/penalty_entity.dart';

class PenaltyModel extends PenaltyEntity {
  const PenaltyModel({
    required super.id,
    required super.amount,
    required super.reason,
    required super.dateIssued,
    required super.employeeName,
    super.workshopName,
    super.adminName,
  });

  factory PenaltyModel.fromJson(Map<String, dynamic> json) {
    // السيرفر يرسل المبالغ كنصوص "200.00" في الـ JSON الجديد
    final amountValue = json['amount'];
    final double parsedAmount = amountValue is num
        ? amountValue.toDouble()
        : double.tryParse(amountValue.toString()) ?? 0.0;

    return PenaltyModel(
      id: json['id'] as int,
      amount: parsedAmount,
      reason: json['reason'] ?? '',
      dateIssued: DateTime.parse(json['date_issued'] ?? DateTime.now().toIso8601String()),
      employeeName: json['employee_name'] ?? 'موظف غير معروف',
      workshopName: json['workshop_name'] ?? 'غير محدد',
      adminName: json['admin_name'] as String?,
    );
  }
}

class PenaltyResponse {
  final List<PenaltyModel> data;

  PenaltyResponse({required this.data});

  factory PenaltyResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataList = json['data'];
    if (dataList is List) {
      return PenaltyResponse(
        data: dataList.map((e) => PenaltyModel.fromJson(e)).toList(),
      );
    } else if (dataList != null) {
      return PenaltyResponse(
        data: [PenaltyModel.fromJson(dataList)],
      );
    } else {
      return PenaltyResponse(data: []);
    }
  }
}
