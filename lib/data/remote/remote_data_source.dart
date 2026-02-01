import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled8/core/unified_api/api_variables.dart'; 
import '../../features/admin/data/models/workshop_model.dart';
import '../../features/Attendance/data/models/attendance_record.dart'; 

class RemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final ApiVariables _apiVariables = ApiVariables(); 

  RemoteDataSource({required this.dio, required this.secureStorage});

  Future<List<WorkshopModel>> getWorkshops() async {
    try {
      final res = await dio.getUri(_apiVariables.workshops());
      final data = res.data;
      
      List<dynamic> listData;
      if (data is List) {
        listData = data;
      } else if (data is Map && data.containsKey('workshops')) {
        listData = data['workshops'];
      } else if (data is Map && data.containsKey('data')) {
        listData = data['data'];
      } else {
        return [];
      }

      return listData
          .map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('General Error in getWorkshops => $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAttendance({required String userId}) async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      debugPrint('DEBUG: Fetching attendance for userId: $userId. Token used: ${token != null && token.isNotEmpty ? token.substring(0, 10) + '...' : 'NONE'}');
      
      final res = await dio.getUri(_apiVariables.getAttendances(params: {'userId': userId}));
      
      if (res.data is List) {
        return List<Map<String, dynamic>>.from(res.data);
      } else if (res.data is Map && res.data.containsKey('data') && res.data['data'] is List) {
        return List<Map<String, dynamic>>.from(res.data['data']);
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        debugPrint('Fetch Attendance Auth Error (${e.response?.statusCode}): Token might be invalid or user lacks permission.');
        return null; 
      }
      debugPrint('Error fetching attendance: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postAttendance(Map<String, dynamic> payload) async {
    try {
      // 🔹 التأكد من استخدام postUri بشكل صحيح
      final res = await dio.postUri(_apiVariables.postAttendance(), data: payload);
      return Map<String, dynamic>.from(res.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        debugPrint('Post Attendance Auth Error (${e.response?.statusCode})');
        // لا ترمي الخطأ هنا، الـ Interceptor سيعالج إعادة التوجيه
      }
      debugPrint('Error posting attendance: $e');
      rethrow;
    }
  }
}
