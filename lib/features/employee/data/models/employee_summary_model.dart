import '../../domain/entities/employee_summary_entity.dart';

class EmployeeSummaryModel extends EmployeeSummaryEntity {
  const EmployeeSummaryModel({
    required super.employeeFullName,
    required super.workshopNames,
    required super.totalRegularHours,
    required super.totalOvertimeHours,
    required super.regularPay,
    required super.overtimePay,
    required super.totalPay,
    required super.currentLocation,
  });

  factory EmployeeSummaryModel.fromJson(Map<String, dynamic> json) {
    final employeeData = json['employee'] as Map<String, dynamic>?;
    final user = employeeData?['user'] as Map<String, dynamic>?;
    final workshops = employeeData?['workshops'] as List?;
    
    final currentLocation = employeeData?['current_location'] ?? 'غير محدد';

    return EmployeeSummaryModel(
      employeeFullName: user?['full_name'] ?? 'اسم غير معروف',
      workshopNames: List<String>.from(workshops?.map((ws) => ws['name']?.toString() ?? '') ?? []),
      totalRegularHours: (json['total_regular_hours'] as num?)?.toDouble() ?? 0.0,
      totalOvertimeHours: (json['total_overtime_hours'] as num?)?.toDouble() ?? 0.0,
      regularPay: (json['regular_pay'] as num?)?.toDouble() ?? 0.0,
      overtimePay: (json['overtime_pay'] as num?)?.toDouble() ?? 0.0,
      totalPay: (json['total_pay'] as num?)?.toDouble() ?? 0.0,
      currentLocation: currentLocation,
    );
  }
}

class EmployeeSummaryResponse {
  final EmployeeSummaryModel data;

  EmployeeSummaryResponse({required this.data});

  factory EmployeeSummaryResponse.fromJson(Map<String, dynamic> json) {
    // التعامل مع الحالة التي تكون فيها البيانات نل أو مفقودة
    final dataMap = (json['data'] is Map) ? json['data'] : (json is Map ? json : {});
    return EmployeeSummaryResponse(
      data: EmployeeSummaryModel.fromJson(dataMap as Map<String, dynamic>),
    );
  }
}
