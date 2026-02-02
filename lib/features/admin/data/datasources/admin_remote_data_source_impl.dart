import 'package:dio/dio.dart';
import '../../../../core/unified_api/api_variables.dart';

import '../models/employee model/employee_model.dart';
import '../models/workshop_model.dart';
import 'admin_remote_data_source.dart';

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;
  final ApiVariables apiVariables = ApiVariables();

  AdminRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Datum>> getOnlineEmployees() async {
    final response = await dio.getUri(apiVariables.employees());

    final list = response.data['data'] as List;
    return list
        .map((e) => Datum.fromJson(e as Map<String, dynamic>))
        .toList();
  }


  @override
  Future<List<Datum>> getAllEmployees() async {
    final response = await dio.getUri(apiVariables.employees());

    if (response.statusCode == 200) {
      final list = response.data['data'] as List;
      // طباعة القائمة للتحقق من محتواها وشكلها
      print('✅ تم استقبال ${list.length} موظف');

      return list
          .map((e) {
        print('قبل التحويل: $e');
        try {
          final datum = Datum.fromJson(e as Map<String, dynamic>);
          print('✅ نجح: ${datum.user?.fullName}');
          return datum;
        } catch (error) {
          print('❌ خطأ: $error');
          rethrow;
        }
      })
          .toList();
    } else {
      throw Exception('Failed to load employees: ${response.statusCode}');
    }
  }



  @override
  Future<Datum> getEmployeeDetails(String id) async {
    final response = await dio.getUri(apiVariables.employeeDetails(id));
    return Datum.fromJson(response.data['data']);
  }

  @override
  Future<void> updateHourlyRate(String id, double rate) async {
    final response = await dio.putUri(
      apiVariables.updateHourlyRate(id),
      data: {'hourly_rate': rate},
    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to update hourly rate: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateOvertimeRate(String id, double rate) async {
    final response = await dio.putUri(
      apiVariables.employeeUpdate(id),
      data: {'overtime_rate': rate},
    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to update overtime rate: ${response.statusCode}');
    }
  }

  @override
  Future<void> confirmPayment(String id, int weekNumber) async {
    final response = await dio.postUri(
      apiVariables.employeeUpdate(id),
      data: {'week_number': weekNumber},
    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to confirm payment: ${response.statusCode}');
    }
  }


  @override
  Future<void> addEmployee(Datum employee) async {
    await dio.postUri(
      apiVariables.addEmployee(),
      data: {
        'name': employee.user?.fullName ?? '',
        'phone_number': employee.user?.phoneNumber ?? '',
        'password': '123456',
        'hourly_rate': employee.hourlyRate ?? 0,
        'overtime_rate': employee.overtimeRate ?? 0,
      },
    );
  }



  @override
  Future<void> deleteEmployee(String id) async {
    final response = await dio.deleteUri(apiVariables.employeeDetails(id));

    if (response.statusCode! >= 400) {
      throw Exception('Failed to delete employee: ${response.statusCode}');
    }
  }

  @override
  Future<void> toggleEmployeeArchive(String id, bool isArchived) async {
    final response = await dio.putUri(
      apiVariables.archiveEmployee(id),
      data: {'is_archived': isArchived},
    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to toggle employee archive: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateEmployee(Datum employee) async {
    await dio.putUri(
      apiVariables.employeeDetails(employee.id.toString()),
      data: {
        'hourly_rate': employee.hourlyRate ?? 0,
        'overtime_rate': employee.overtimeRate ?? 0,
      },
    );
  }



    @override
  Future<List<WorkshopModel>> getWorkshops() async {
    final response = await dio.getUri(apiVariables.workshops());

    if (response.statusCode == 200) {
      // ✅ تحقق من شكل البيانات
      if (response.data is List) {
        // لو البيانات list مباشرة
        final list = response.data as List;
        return list.map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>)).toList();
      } else if (response.data is Map) {
        // لو البيانات wrapped في {data: [...]}
        final data = response.data as Map<String, dynamic>;
        final list = data['data'] as List? ?? [];
        return list.map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    throw Exception('Failed to load workshops: ${response.statusCode}');
  }

  @override
  Future<void> addWorkshop({

    required String name,
    required String location,
    required String description,
    double? latitude,
    double? longitude,
    double radius = 200,
  }) async {
    final response = await dio.postUri(
      apiVariables.addWorkshop(),
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: {
        'location': location,
        'description': description,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      },

    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to add workshop: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteWorkshop(String id) async {
    final response = await dio.deleteUri(apiVariables.workshopDetails(id));

    if (response.statusCode! >= 400) {
      throw Exception('Failed to delete workshop: ${response.statusCode}');
    }
  }

  @override
  Future<void> toggleWorkshopArchive(String id, bool isArchived) async {
    final response = await dio.putUri(
      apiVariables.archiveWorkshop(id),
      data: {'is_archived': isArchived},
    );

    if (response.statusCode! >= 400) {
      throw Exception('Failed to toggle workshop archive: ${response.statusCode}');
    }
  }
}
