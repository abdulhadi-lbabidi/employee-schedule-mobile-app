import 'package:dio/dio.dart';

import '../../common/helper/src/typedef.dart';
import 'error_handler.dart';
import 'failures.dart';

mixin HandlingApiManager {
  Future<T> wrapHandlingApi<T>(
      {required Future<Response> Function() tryCall,
        required FromJson<T> jsonConvert,


      })
  async {
    try {
      final  response = await tryCall();
      if (response.statusCode == ResponseCode.SUCCESS ||
          response.statusCode == ResponseCode.NO_CONTENT ||
          response.statusCode == ResponseCode.DELETED) {
        return jsonConvert!(response.data);
      } else {
        throw ServerFailure(
          message: response.data["message"].toString(),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
