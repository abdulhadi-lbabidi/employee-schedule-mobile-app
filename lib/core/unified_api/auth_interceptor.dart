import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import '../../features/SplashScreen/presentation/page/splashScareen.dart';
import '../di/injection.dart';
import '../../../main.dart';

class AuthInterceptor extends Interceptor {
  bool _isRedirecting = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 🔹 لا ترسل التوكن إذا كان الطلب لتسجيل الدخول أو التسجيل
    if (options.path.contains('login') || options.path.contains('register')) {
      return handler.next(options);
    }

    final storage = sl<FlutterSecureStorage>();
    final token = await storage.read(key: 'auth_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint("DEBUG: Interceptor attached token to ${options.path}");
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 🔹 إذا كان الخطأ 401 والطلب ليس تسجيل دخول، قم بتسجيل الخروج
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('login')) {
      if (!_isRedirecting) {
        _isRedirecting = true;
        debugPrint(
          "DEBUG: Session Expired (401) on ${err.requestOptions.path}",
        );
        _handleUnauthorized();

        Future.delayed(const Duration(seconds: 3), () {
          _isRedirecting = false;
        });
      }
    }
    return handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    final storage = sl<FlutterSecureStorage>();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_data');

    AppVariables.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Splashscareen()),
      (route) => false,
    );

    debugPrint("Session Expired: Redirected to Splash Screen");
  }
}
