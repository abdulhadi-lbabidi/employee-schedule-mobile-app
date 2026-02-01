import '../../domain/entities/employee_entity.dart';
import '../models/employee model/employee_model.dart';
import '../models/workshop_model.dart';

extension DatumToEmployeeEntity on Datum {
  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id.toString(),
      name: user.fullName,
      phoneNumber: user.phoneNumber,
      imageUrl: user.profileImageUrl ?? '', // إذا null استخدم فارغ
      currentLocation: currentLocation,
      isOnline: isOnline,
      workshopName: workshops.isNotEmpty
          ? (workshops.first.name ?? 'Unknown')
          : 'Unknown',
      dailyWorkHours: 8.0,
      weeklyHistory: [],
      weeklyOvertime: 0.0,
      hourlyRate: hourlyRate.toDouble(),
      overtimeRate: overtimeRate.toDouble(),
      isArchived: false,
      password: '',
      position: position,
      department: department,
      email: user.email,
      workshops: workshops.map((w) => WorkshopModel.toEntity(w)).toList(),
    );
  }
}
