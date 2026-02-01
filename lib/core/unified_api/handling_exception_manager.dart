import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

mixin HandlingExceptionManager {
  /// يقوم بتغليف أي طلب API ومعالجة أخطائه تلقائياً
  Future<Either<Failure, T>> wrapHandling<T>({
    required Future<T> Function() tryCall,
  }) async {
    try {
      final result = await tryCall();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure("انتهت مهلة الاتصال، تحقق من جودة الإنترنت");
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? "خطأ في بيانات السيرفر";
        
        if (statusCode == 401) return const AuthFailure("انتهت الجلسة، يرجى تسجيل الدخول مجدداً");
        if (statusCode == 403) return const AuthFailure("لا تملك صلاحية للقيام بهذا الإجراء");
        return ServerFailure(message);

      case DioExceptionType.cancel:
        return const ServerFailure("تم إلغاء الطلب");
        
      case DioExceptionType.connectionError:
        return const NetworkFailure("لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقاً");
      default:
        return const ServerFailure("حدث خطأ في الاتصال بالشبكة");
    }
  }
}
