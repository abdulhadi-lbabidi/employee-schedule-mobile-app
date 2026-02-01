import 'package:untitled8/features/admin/domain/entities/workshop_entity.dart';

class EmployeeEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final String? imageUrl;
  final String currentLocation;
  final bool isOnline;
  final String workshopName;
  final double dailyWorkHours;
  final List<WeeklyWorkHistory> weeklyHistory;
  final double weeklyOvertime;
  final double hourlyRate;
  final double overtimeRate;
  final bool isArchived;
  final String password;

  // ✅ الحقول الإضافية المستلمة من الـ API
  final String? position;
  final String? department;
  final String? email;
  final List<WorkshopEntity>? workshops;

  EmployeeEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOKIvbFjH7NUlqwrnkImuF_k2tGLS3wwSDCw&s',
    required this.currentLocation,
    required this.isOnline,
    required this.workshopName,
    required this.dailyWorkHours,
    required this.weeklyHistory,
    required this.weeklyOvertime,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.isArchived,
    required this.password,
    this.position,
    this.department,
    this.email,
    this.workshops,
  });

  /// 💰 الرصيد الإجمالي غير المدفوع (Unpaid Balance)
  double get unpaidBalance {
    double totalRemaining = 0.0;
    for (var history in weeklyHistory) {
      totalRemaining += history.remainingAmount(hourlyRate, overtimeRate);
    }
    return totalRemaining;
  }

  /// 📅 عدد الأيام التي سجل فيها الحضور
  int get daysAttended {
    return weeklyHistory.length;
  }
}

// يتم وضع الـ Extension خارج الكلاس بشكل صحيح
extension EmployeeEntityCopyWith on EmployeeEntity {
  EmployeeEntity copyWith({
    String? name,
    String? password,
    String? phoneNumber,
    String? workshopName,
    double? hourlyRate,
    double? overtimeRate,
    bool? isArchived,
    List<WeeklyWorkHistory>? weeklyHistory,
    String? position,
    String? department,
    String? email,
    List<WorkshopEntity>? workshops,
  }) {
    return EmployeeEntity(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl,
      currentLocation: currentLocation,
      isOnline: isOnline,
      workshopName: workshopName ?? this.workshopName,
      dailyWorkHours: dailyWorkHours,
      weeklyHistory: weeklyHistory ?? this.weeklyHistory,
      weeklyOvertime: weeklyOvertime,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      overtimeRate: overtimeRate ?? this.overtimeRate,
      isArchived: isArchived ?? this.isArchived,
      password: password ?? this.password,
      position: position ?? this.position,
      department: department ?? this.department,
      email: email ?? this.email,
      workshops: workshops ?? this.workshops,
    );
  }
}

class WeeklyWorkHistory {
  final int weekNumber;
  final int month; // 🔹 مضاف
  final int year; // 🔹 مضاف
  final List<WorkshopWorkData> workshops;
  final bool isPaid;
  final double amountPaid;

  WeeklyWorkHistory({
    required this.weekNumber,
    required this.month,
    required this.year,
    required this.workshops,
    required this.isPaid,
    this.amountPaid = 0.0,
  });

  double totalAmount(double regRate, double otRate) {
    double total = 0;
    for (var ws in workshops) {
      total += ws.calculateValue(regRate, otRate);
    }
    return total;
  }

  double remainingAmount(double regRate, double otRate) {
    return totalAmount(regRate, otRate) - amountPaid;
  }
}

class WorkshopWorkData {
  final String workshopName;
  final double regularHours;
  final double overtimeHours;

  WorkshopWorkData({
    required this.workshopName,
    required this.regularHours,
    required this.overtimeHours,
  });

  double calculateValue(double? regRate, double? otRate) {
    final rRate = regRate ?? 0.0;
    final oRate = otRate ?? 0.0;
    return (regularHours * rRate) + (overtimeHours * oRate);
  }
}
