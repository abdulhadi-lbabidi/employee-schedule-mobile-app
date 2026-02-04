import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/helper/src/prefs_keys.dart';
import '../di/injection.dart';
import 'base_api.dart';
import 'failures.dart';

mixin HandlingException {
  final InternetConnectionChecker _checkerClass = InternetConnectionChecker.instance;

  Future<Either<Failure, T>> wrapHandlingException<T>({
    required Future<T> Function() tryCall,
    Future<T> Function()? otherCall,
  }) async {
    final hasInternet = await _checkerClass.hasConnection;

    if (!hasInternet && otherCall != null) {
      try {
        final result = await otherCall();
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    }

    try {
      final result = await tryCall();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}


class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      print('else state');
      // default error
      failure = ServerFailure(
        message: error.toString(),
        statusCode: ResponseCode.BAD_REQUEST_Server,
      );
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.unknown:
        return DataSource.DEFAULT.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.BAD_REQUEST.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.NO_INTERNET_CONNECTION.getFailure();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case ResponseCode.INTERNAL_SERVER_ERROR:
            return DataSource.INTERNAL_SERVER_ERROR.getFailure();
          case ResponseCode.NOT_FOUND:
            return DataSource.NOT_FOUND.getFailure();
          case ResponseCode.FORBIDDEN:
            return DataSource.FORBIDDEN.getFailure();
          case ResponseCode.UNAUTHORISED:
            sl<SharedPreferences>().remove(PrefsKeys.token);
            sl<SharedPreferences>().remove(PrefsKeys.userInfo);
            sl<BaseApi>().resetHeader();
            // AppVariables.navigatorKey.currentContext?.pushNamedAndRemoveUntil(
            //   RouteName.splash,
            //   (route) => false,
            // );
            return UnauthenticatedFailure(
              message: AppConstants.unauthorizedError,
            );
          case ResponseCode.BLOCKED:
            return UserBlockedFailure(message: AppConstants.blockedError);
          case ResponseCode.NOT_ALLOWED:
            return UserNotAllowedFailure(message: AppConstants.notAllowed);
          case ResponseCode.Bad_Content:
            return ServerFailure(
              message:
                  ErrorMessageModel.fromJson(
                    error.response?.data,
                  ).statusMessage,
              statusCode: ResponseCode.Bad_Content,
            );
          case ResponseCode.BAD_REQUEST_Server:
            return ServerFailure(
              message:
                  ErrorMessageModel.fromJson(
                    error.response?.data,
                  ).statusMessage,
              statusCode: ResponseCode.BAD_REQUEST_Server,
            );
          default:
            return ServerFailure(
              message:
                  error.response?.data is! Map
                      ? ResponseMessage.INTERNAL_SERVER_ERROR
                      : error.response?.data["errors"]?.toString() ??
                          error.response?.data["message"]?.toString() ??
                          '',
              statusCode:
                  error.response?.statusCode ?? ResponseCode.BAD_REQUEST,
            );
        }
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return ServerFailure(
          statusCode: ResponseCode.SUCCESS,
          message: ResponseMessage.SUCCESS,
        );
      case DataSource.NO_CONTENT:
        return ServerFailure(
          statusCode: ResponseCode.SUCCESS,
          message: ResponseMessage.NO_CONTENT,
        );
      case DataSource.BAD_REQUEST:
        return ServerFailure(
          statusCode: ResponseCode.BAD_REQUEST,
          message: ResponseMessage.BAD_REQUEST,
        );
      case DataSource.FORBIDDEN:
        return ServerFailure(
          statusCode: ResponseCode.FORBIDDEN,
          message: ResponseMessage.FORBIDDEN,
        );
      case DataSource.UNAUTORISED:
        return ServerFailure(
          statusCode: ResponseCode.UNAUTHORISED,
          message: ResponseMessage.UNAUTORISED,
        );
      case DataSource.NOT_FOUND:
        return ServerFailure(
          statusCode: ResponseCode.NOT_FOUND,
          message: ResponseMessage.NOT_FOUND,
        );
      case DataSource.INTERNAL_SERVER_ERROR:
        return ServerFailure(
          statusCode: ResponseCode.INTERNAL_SERVER_ERROR,
          message: ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return ServerFailure(
          statusCode: ResponseCode.CONNECT_TIMEOUT,
          message: ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return ServerFailure(
          statusCode: ResponseCode.CANCEL,
          message: ResponseMessage.CANCEL,
        );
      case DataSource.RECIEVE_TIMEOUT:
        return ServerFailure(
          statusCode: ResponseCode.RECIEVE_TIMEOUT,
          message: ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return ServerFailure(
          statusCode: ResponseCode.SEND_TIMEOUT,
          message: ResponseMessage.SEND_TIMEOUT,
        );
      case DataSource.CACHE_ERROR:
        return ServerFailure(
          statusCode: ResponseCode.CACHE_ERROR,
          message: ResponseMessage.CACHE_ERROR,
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return ServerFailure(
          statusCode: ResponseCode.NO_INTERNET_CONNECTION,
          message: ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.DEFAULT:
        return ServerFailure(
          statusCode: ResponseCode.DEFAULT,
          message: ResponseMessage.DEFAULT,
        );
      case DataSource.DELETED:
        return ServerFailure(
          message: ResponseMessage.SUCCESS,
          statusCode: ResponseCode.DELETED,
        );
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int DELETED = 204; // success with no data (no content)
  static const int BAD_REQUEST = 400; // ServerFailure, API rejected request
  static const int UNAUTHORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found
  static const int NOT_ALLOWED = 405; // failure, not allowed
  static const int BLOCKED = 420; // failure,blocked
  static const int Bad_Content = 422; // failure, Bad_Content
  static const int BAD_REQUEST_Server =
      402; // ServerFailure, API rejected request

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = AppConstants.success; // success with data
  static const String Deleted = AppConstants.success; // success with data
  static const String NO_CONTENT =
      AppConstants.success; // success with no data (no content)
  static const String BAD_REQUEST =
      AppConstants.badRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      AppConstants.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      AppConstants.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      AppConstants.internalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      AppConstants.notFoundError; // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = AppConstants.timeoutError;
  static const String CANCEL = AppConstants.defaultError;
  static const String RECIEVE_TIMEOUT = AppConstants.timeoutError;
  static const String SEND_TIMEOUT = AppConstants.timeoutError;
  static const String CACHE_ERROR = AppConstants.cacheError;
  static const String NO_INTERNET_CONNECTION = AppConstants.noInternetError;
  static const String DEFAULT = AppConstants.defaultError;
}

class AppConstants {
  AppConstants._();

  // error handler
  static const String success = 'نجاح';
  static const String deleted = 'نجاح';
  static const String badRequestError = "طلب غير صحيح";
  static const String noContent = "لا يوجد محتوى";
  static const String forbiddenError = "ممنوع";
  static const String unauthorizedError =
      "غير مسجل يرجى التسجيل أولا"; //"unauthorized_error";
  static const String notFoundError =
      "الحساب غير موجود، تحقق منه أو أنشئ حساباً";
  static const String conflictError = "تعارض";
  static const String blockedError = "محظور";
  static const String internalServerError =
      "خطأ بالاتصال بالسيرفر"; //"internal_server_error";
  static const String notAllowed =
      "غير مسموح لك هذا الأمر"; //"internal_server_error";

  static const String unknownError = "خطأ غير معروف";
  static const String timeoutError =
      "انتهى وقت الاتصال تحقق من الانترنت وحاول مجددا"; //"timeout_error"
  static const String defaultError = "خطأ افتراضي";
  static const String cacheError = "خطأ في الذاكرة المؤقتة";
  static const String noInternetError =
      "تحقق من اتصالك بالإنترنت ثم حاول مرة أخرى"; //"no_internet_error"
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}

// ignore_for_file: constant_identifier_names
enum DataSource {
  SUCCESS,
  NO_CONTENT,
  DELETED,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

class ErrorMessageModel extends Equatable {
  final String statusMessage;
  final bool success;

  const ErrorMessageModel({required this.statusMessage, required this.success});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    String error = "";
    if (json["message"] is Map) {
      for (var item in (json["message"] as Map<String, dynamic>).entries) {
        error = "${error.isEmpty ? "" : "$error \n"} ${item.value}";
      }
    } else {
      error = json["message"].toString();
    }
    return ErrorMessageModel(
      statusMessage: error,
      success: json["success"] ?? false,
    );
  }

  @override
  List<Object?> get props => [statusMessage, success];
}
