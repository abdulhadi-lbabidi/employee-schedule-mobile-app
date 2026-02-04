import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';
import '../mappers/employee_mapper.dart';
import '../mappers/employee_to_datum_mapper.dart';
import '../mappers/workshop_mapper.dart';
import '../models/employee model/employee_model.dart';

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remote;

  AdminRepositoryImpl(this.remote);

  /// تحويل Datum إلى EmployeeEntity باستخدام الـ EmployeeMapper
  EmployeeEntity _datumToEntity(Datum datum) {
    return DatumToEmployeeEntity(datum).toEntity();
  }

  @override
  Future<List<EmployeeEntity>> getOnlineEmployees() async {
    final data = await remote.getOnlineEmployees();
    return data.map((d) => _datumToEntity(d)).toList();
  }


  @override
  Future<List<EmployeeEntity>> getAllEmployees() async {
    print('🔹 getAllEmployees() called in Repository'); // تأكيد الوصول للدالة

    final data = await remote.getAllEmployees();

    print('🔹 RAW data count: ${data.length}'); // عدد العناصر الواردة
    for (var i = 0; i < data.length; i++) {
      print('🔹 Datum [$i]: ${data[i]}'); // محتوى كل عنصر Datum
    }

    final entities = <EmployeeEntity>[];
    for (var i = 0; i < data.length; i++) {
      try {
        final e = data[i].toEntity(); // تحويل إلى Entity
        entities.add(e);
        print('✅ Converted Entity [$i]: ${e.name}'); // تأكيد التحويل
      } catch (e, s) {
        print('❌ Error converting Datum [$i]: $e');
        print(s);
      }
    }

    print('🔹 Total Entities returned: ${entities.length}');
    return entities;
  }


  @override
  Future<EmployeeEntity> getEmployeeDetails(String id) async {
    final datum = await remote.getEmployeeDetails(id);
    return _datumToEntity(datum);
  }

  @override
  Future<void> updateHourlyRate({
    required String employeeId,
    required double newRate,
  }) {
    return remote.updateHourlyRate(employeeId, newRate);
  }

  @override
  Future<void> updateOvertimeRate({
    required String employeeId,
    required double newRate,
  }) {
    return remote.updateOvertimeRate(employeeId, newRate);
  }

  @override
  Future<void> confirmPayment({
    required String employeeId,
    required int weekNumber,
  }) {
    return remote.confirmPayment(employeeId, weekNumber);
  }

  @override
  Future<void> addEmployee(EmployeeEntity employee) async {
    try {
      // ✅ التصحيح: استدعاء toDatumModel() كـ Extension
      final datum = employee.toDatumModel();
      return await remote.addEmployee(datum);
    } catch (e) {
      debugPrint('Error in addEmployee: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEmployee(String id) {
    return remote.deleteEmployee(id);
  }

  @override
  Future<void> toggleEmployeeArchive(String id, bool isArchived) {
    return remote.toggleEmployeeArchive(id, isArchived);
  }

  @override
  Future<void> updateEmployee(EmployeeEntity employee) async {
    try {
      // ✅ التصحيح: استدعاء toDatumModel() كـ Extension
      final datum = employee.toDatumModel();
      return await remote.updateEmployee(datum);
    } catch (e) {
      debugPrint('Error in updateEmployee: $e');
      rethrow;
    }
  }



  @override
  Future<List<WorkshopEntity>> getWorkshops() async {
    final models = await remote.getWorkshops();
    return models.map(WorkshopMapper.toEntity).toList();
  }

  @override
  Future<void> addWorkshop({
    required String name,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) {
    return remote.addWorkshop(
      name: name,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }

  @override
  Future<void> deleteWorkshop(int id) {
    return remote.deleteWorkshop(id);
  }

  @override
  Future<void> toggleWorkshopArchive(String id, bool isArchived) {
    return remote.toggleWorkshopArchive(id, isArchived);
  }
}