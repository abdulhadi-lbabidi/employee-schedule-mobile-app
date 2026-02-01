import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../../../core/unified_api/failures.dart';
import '../model/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl extends BaseApi implements AuthRemoteDataSource {
  final ApiVariables apiVariables = ApiVariables();

  AuthRemoteDataSourceImpl({required Dio dio}) : super(dio);

  @override
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    // سنستخدم الـ raw call هنا لأننا سنعالج النتيجة في الـ Repository 
    // أو يمكننا استخدام wrapHandling إذا أردنا توحيد الأخطاء
    final response = await dio.postUri(
      apiVariables.login(),
      data: {
        'email': email,
        'password': password,
      },
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<bool> verifyToken(String token) async {
    try {
      final response = await dio.getUri(
        apiVariables.verifyToken(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<LoginResponse> register({
    required String username,
    required String password,
    required String email,
    required String fullName,
    required String role,
  }) async {
    final response = await dio.postUri(
      apiVariables.register(),
      data: {
        'username': username,
        'password': password,
        'email': email,
        'full_name': fullName,
        'role': role,
      },
    );
    return LoginResponse.fromJson(response.data);
  }
}
