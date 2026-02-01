import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'failures.dart';
import 'handling_exception_manager.dart';

class BaseApi with HandlingExceptionManager {
  final Dio dio;

  BaseApi(this.dio); // إزالة إضافة الـ Interceptor من هنا لتجنب التكرار

  /// تنفيذ طلب GET بطريقة آمنة
  Future<Either<Failure, T>> get<T>({
    required Uri uri,
    required T Function(dynamic json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    return wrapHandling(
      tryCall: () async {
        Uri finalUri = uri;
        if (queryParameters != null && queryParameters.isNotEmpty) {
          finalUri = uri.replace(
            queryParameters: {
              ...uri.queryParameters,
              ...queryParameters.map((key, value) => MapEntry(key, value.toString())),
            },
          );
        }
        
        final response = await dio.getUri(finalUri);
        return fromJson(response.data);
      },
    );
  }

  /// تنفيذ طلب POST بطريقة آمنة
  Future<Either<Failure, T>> post<T>({
    required Uri uri,
    required T Function(dynamic json) fromJson,
    dynamic body,
  }) async {
    return wrapHandling(
      tryCall: () async {
        final response = await dio.postUri(
          uri,
          data: body,
        );
        return fromJson(response.data);
      },
    );
  }

  /// تنفيذ طلب PUT بطريقة آمنة
  Future<Either<Failure, T>> put<T>({
    required Uri uri,
    required T Function(dynamic json) fromJson,
    dynamic body,
  }) async {
    return wrapHandling(
      tryCall: () async {
        final response = await dio.putUri(
          uri,
          data: body,
        );
        return fromJson(response.data);
      },
    );
  }

  /// تنفيذ طلب DELETE بطريقة آمنة
  Future<Either<Failure, T>> delete<T>({
    required Uri uri,
    required T Function(dynamic json) fromJson,
  }) async {
    return wrapHandling(
      tryCall: () async {
        final response = await dio.deleteUri(uri);
        return fromJson(response.data);
      },
    );
  }
}
