import '../../domain/entities/employee_entity.dart';
import '../models/employee model/employee_model.dart';
import '../models/workshop_model.dart';

extension EmployeeEntityToModel on EmployeeEntity {
  Datum toDatumModel() {
    final id = int.tryParse(this.id);
    if (id == null) {
      throw ArgumentError('Invalid employee ID for model conversion: ${this.id}');
    }

    return Datum(
      id: id,
      position: this.position ?? 'Unknown',
      department: this.department ?? 'Unknown',
      // ملاحظة: تم تحويل المعدلات إلى Int كما كان في الـ Model الأصلي
      hourlyRate: this.hourlyRate.toDouble(),
      overtimeRate: this.overtimeRate.toDouble(),
      isOnline: this.isOnline,
      currentLocation: this.currentLocation,
      user: UserModel(
        id: id,
        fullName: this.name,
        phoneNumber: this.phoneNumber,
        email: this.email ?? '',
        profileImageUrl: this.imageUrl,
      ),
      workshops: this.workshops
          ?.map((w) => WorkshopModel.fromEntity(w))
          .toList() ?? [],
    );
  }
}