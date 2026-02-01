import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import '../../../admin/data/models/workshop_model.dart';


class WorkshopsRepository {
  final Dio dio;
  final Box<WorkshopModel> workshopsBox;
  final Connectivity connectivity;

  WorkshopsRepository({
    required this.dio,
    required this.workshopsBox,
    required this.connectivity,
  });

  Future<bool> _isOnline() async {
    final res = await connectivity.checkConnectivity();
    return res != ConnectivityResult.none;
  }

  // ==================== جلب البيانات (GET) ====================

  Future<List<WorkshopModel>> getWorkshops() async {
    if (await _isOnline()) {
      try {
        final response = await dio.get('/workshops');
        final data = response.data;
        List<dynamic> rawList = data is List ? data : (data['workshops'] ?? data['data'] ?? []);
        final workshops = rawList.map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>)).toList();

        // تحديث التخزين المحلي
        await workshopsBox.clear();
        await workshopsBox.addAll(workshops);

        return workshops;
      } catch (e) {
        print("Remote fetch failed, fallback to local: $e");
      }
    }
    // العودة للبيانات المحلية في حال عدم وجود إنترنت أو فشل الطلب
    return workshopsBox.values.toList();
  }

  // تم حذف دالة getLogisticTeams

  // ==================== إدارة الورشات (ADMIN ACTIONS) ====================

  Future<bool> addWorkshop(String name, String location, int customerId) async {
    try {
      final response = await dio.post('/workshops', data: {
        'name': name,
        'location': location,
        'customer_id': customerId,
      });
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteWorkshop(int id) async {
    try {
      final response = await dio.delete('/workshops/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}