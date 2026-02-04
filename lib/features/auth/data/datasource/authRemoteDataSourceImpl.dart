import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../model/login_response.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRemoteDataSourceImpl with HandlingApiManager {
  final BaseApi _baseApi;

  AuthRemoteDataSourceImpl({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<LoginResponse> login({
    required String email,
    required String password,
  })
  async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
            ApiVariables.login(),
            data: {'email': email, 'password': password},
          ),
      jsonConvert: loginResponseFromJson,
    );
  }

  Future<bool> verifyToken(String token)
  async {
    try {
      final response = await _baseApi.get(ApiVariables.verifyToken());
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<LoginResponse> register({
    required String username,
    required String password,
    required String email,
    required String fullName,
    required String role,
  })
  async {
    final response = await _baseApi.post(
      ApiVariables.register(),
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


  Future<LoginResponse> getMe()
  async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.get(
        ApiVariables.getProfile(),
      ),
      jsonConvert: loginResponseFromJson,
    );
  }

}
