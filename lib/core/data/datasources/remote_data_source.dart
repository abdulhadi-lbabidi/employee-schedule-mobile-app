import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../features/Attendance/data/model/work/workshope.dart';

class RemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  RemoteDataSource({required this.dio, required this.secureStorage}) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await secureStorage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }));
  }

  Future<List<Workshope>> getWorkshops() async {
    try {
      final res = await dio.get('/workshops');
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

      return listData.map((e) => Workshope.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // باقي الدوال العامة...
}
