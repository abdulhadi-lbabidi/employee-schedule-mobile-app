import 'package:injectable/injectable.dart';

import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../models/workshop_model.dart';

@lazySingleton
class WorkshopRemoteDataSource {
  final BaseApi _baseApi;

  WorkshopRemoteDataSource({required BaseApi baseApi}) : _baseApi = baseApi;

  @override
  Future<List<WorkshopModel>> getWorkshops() async {
    final response = await _baseApi.get(ApiVariables.workshops());

    if (response.statusCode == 200) {
      // تصحيح: التحقق إذا كانت البيانات تأتي داخل مفتاح 'data'
      final dynamic rawData = response.data;
      List<dynamic> list;

      if (rawData is Map && rawData.containsKey('data')) {
        list = rawData['data'] as List;
      } else if (rawData is List) {
        list = rawData;
      } else {
        throw Exception('Unexpected data format: ${rawData.runtimeType}');
      }

      return list
          .map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load workshops: ${response.statusCode}');
    }
  }
}
