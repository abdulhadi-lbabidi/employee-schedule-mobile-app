import 'dart:async';

import 'package:dio/dio.dart';

class ApiTester {
  final Dio dio = Dio();
  final String baseUrl = 'https://employee-api.nouh-agency.com';

  Future<void> testAllEndpoints() async {
    print('🚀 بدء اختبار جميع الروابط...\n');

    // --- Auth Endpoints ---
    await _testEndpoint('POST', '/api/login', 'تسجيل الدخول');
    await _testEndpoint('POST', '/api/logout', 'تسجيل الخروج');
    await _testEndpoint('PUT', '/api/update-profile', 'تحديث الملف الشخصي');
    await _testEndpoint('GET', '/api/me', 'البيانات الشخصية');
    await _testEndpoint('PUT', '/api/update-password', 'تحديث كلمة المرور');
    await _testEndpoint('POST', '/api/auth/register', 'التسجيل');
    await _testEndpoint('POST', '/api/auth/verify', 'التحقق من التوكن');

    print('\n' + '='*50 + '\n');

    // --- Profile Endpoints ---
    await _testEndpoint('GET', '/api/profile', 'الملف الشخصي');
    await _testEndpoint('PUT', '/api/profile/update', 'تحديث الملف');
    await _testEndpoint('POST', '/api/profile/upload-avatar', 'تحميل الصورة');

    print('\n' + '='*50 + '\n');

    // --- Admin Dashboard ---
    await _testEndpoint('GET', '/api/admin/dashboard/stats', 'إحصائيات المرمى');
    await _testEndpoint('GET', '/api/admin/finance/report', 'التقرير المالي');

    print('\n' + '='*50 + '\n');

    // --- Employees ---
    await _testEndpoint('GET', '/api/admin/employees/is_online', 'حالة الموظفين');
    await _testEndpoint('GET', '/api/employees', 'جميع الموظفين');
    await _testEndpoint('POST', '/api/employees', 'إضافة موظف');
    await _testEndpoint('GET', '/api/employees/1', 'تفاصيل موظف');
    await _testEndpoint('PUT', '/api/employees/1', 'تحديث موظف');
    await _testEndpoint('GET', '/api/employees-archived', 'الموظفين المؤرشفين');
    await _testEndpoint('PUT', '/api/employees/1/hourly_rate', 'تحديث الراتب الساعي');

    print('\n' + '='*50 + '\n');

    // --- Workshops ---
    await _testEndpoint('GET', '/api/workshops/', 'جميع الورشات');
    await _testEndpoint('POST', '/api/workshops', 'إضافة ورشة');
    await _testEndpoint('GET', '/api/workshops/1', 'تفاصيل ورشة');
    await _testEndpoint('PUT', '/api/workshops/1', 'تحديث ورشة');
    await _testEndpoint('GET', '/api/workshops-archived', 'الورشات المؤرشفة');

    print('\n' + '='*50 + '\n');

    // --- Attendance ---
    await _testEndpoint('GET', '/api/attendance', 'الحضور');
    await _testEndpoint('POST', '/api/attendance', 'تسجيل حضور');
    await _testEndpoint('GET', '/api/attendance/employee/1', 'حضور الموظف');

    print('\n' + '='*50 + '\n');

    // --- Loans ---
    await _testEndpoint('GET', '/api/admin/loans', 'قائمة القروض');
    await _testEndpoint('GET', '/api/admin/loans/1/status', 'حالة القرض');

    print('\n' + '='*50 + '\n');

    // --- Rewards ---
    await _testEndpoint('GET', '/api/rewards/admin', 'الجوائز');
    await _testEndpoint('POST', '/api/rewards/issue', 'منح جائزة');

    print('\n' + '='*50 + '\n');

    // --- Notifications ---
    await _testEndpoint('GET', '/api/notifications', 'الإشعارات');
    await _testEndpoint('POST', '/api/notifications/send', 'إرسال إشعار');

    print('\n✅ انتهى الاختبار!\n');
  }

  Future<void> _testEndpoint(
      String method,
      String path,
      String description,
      ) async {
    final url = '$baseUrl$path';

    try {
      Response response;

      if (method == 'GET') {
        response = await dio.get(url).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Timeout'),
        );
      } else if (method == 'POST') {
        response = await dio.post(url, data: {}).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Timeout'),
        );
      } else if (method == 'PUT') {
        response = await dio.put(url, data: {}).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Timeout'),
        );
      } else {
        response = await dio.delete(url).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('Timeout'),
        );
      }

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        print('✅ $method $path - $description');
        print('   Status: $statusCode');
      } else if (statusCode >= 400 && statusCode < 500) {
        print('⚠️  $method $path - $description');
        print('   Status: $statusCode (Client Error)');
      } else if (statusCode >= 500) {
        print('❌ $method $path - $description');
        print('   Status: $statusCode (Server Error)');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('⏱️  $method $path - $description');
        print('   Error: Connection Timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        print('❌ $method $path - $description');
        print('   Error: Connection Error - ${e.message}');
      } else if (e.type == DioExceptionType.badResponse) {
        print('⚠️  $method $path - $description');
        print('   Status: ${e.response?.statusCode} - ${e.message}');
      } else {
        print('❌ $method $path - $description');
        print('   Error: ${e.message}');
      }
    } catch (e) {
      print('❌ $method $path - $description');
      print('   Error: $e');
    }
  }
}

// الاستخدام:
// void main() async {
//   final tester = ApiTester();
//   await tester.testAllEndpoints();
// }