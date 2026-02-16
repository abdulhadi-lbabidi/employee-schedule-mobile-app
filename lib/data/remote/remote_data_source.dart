// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:injectable/injectable.dart';
// import 'package:untitled8/core/unified_api/api_variables.dart';
// import '../../features/admin/data/models/workshop_model.dart';
// import '../../features/Attendance/data/models/attendance_record.dart';
//
// @lazySingleton
// class RemoteDataSource {
//   final Dio dio;
//   final FlutterSecureStorage secureStorage;
//
//   RemoteDataSource({required this.dio, required this.secureStorage});
//
//   Future<List<WorkshopModel>> getWorkshops() async {
//     try {
//       final res = await dio.getUri(ApiVariables.workshops());
//       final data = res.data;
//
//       List<dynamic> listData;
//       if (data is List) {
//         listData = data;
//       } else if (data is Map && data.containsKey('workshops')) {
//         listData = data['workshops'];
//       } else if (data is Map && data.containsKey('data')) {
//         listData = data['data'];
//       } else {
//         return [];
//       }
//
//       return listData
//           .map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       debugPrint('General Error in getWorkshops => $e');
//       rethrow;
//     }
//   }
//
//   Future<List<Map<String, dynamic>>?> fetchAttendance({
//     required int userId,
//   }) async {
//     try {
//       final token = await secureStorage.read(key: 'auth_token');
//       debugPrint(
//         'DEBUG: Fetching attendance for userId: $userId. Token used: ${token != null && token.isNotEmpty ? token.substring(0, 10) + '...' : 'NONE'}',
//       );
//
//       final res = await dio.getUri(
//         ApiVariables.getAttendances(params: {'userId': userId.toString()}),
//       );
//
//       if (res.data is List) {
//         return List<Map<String, dynamic>>.from(res.data);
//       } else if (res.data is Map &&
//           res.data.containsKey('data') &&
//           res.data['data'] is List) {
//         return List<Map<String, dynamic>>.from(res.data['data']);
//       }
//       return [];
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
//         debugPrint(
//           'Fetch Attendance Auth Error (${e.response?.statusCode}): Token might be invalid or user lacks permission.',
//         );
//         return null;
//       }
//       debugPrint('Error fetching attendance: $e');
//       rethrow;
//     }
//   }
//
//   Future<Map<String, dynamic>> postAttendance(
//     Map<String, dynamic> payload,
//   ) async {
//     try {
//       final val = {
//         'workshop_id': 2,
//         'date': '2026-02-02',
//         'check_in': '14:10',
//         'check_out': '14:27',
//         'week_number': 2,
//         'note': 'sadasd',
//         'employee_id': 1,
//         "regular_hours": 2,
//         "overtime_hours": 0,
//         "status": "مؤرشف",
//         "note": "دخول",
//         "check_out": "01:00:00",
//       };
//       print(val);
//       final res = await dio.postUri(ApiVariables.postAttendance(), data: val);
//       return Map<String, dynamic>.from(res.data);
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
//         debugPrint('Post Attendance Auth Error (${e.response?.statusCode})');
//         // لا ترمي الخطأ هنا، الـ Interceptor سيعالج إعادة التوجيه
//       }
//       debugPrint('Error posting attendance: $e');
//       rethrow;
//     }
//   }
// }
