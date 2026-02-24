import 'dart:io';

import 'package:dio/dio.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../../../common/helper/src/app_varibles.dart';
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
            options: Options(headers: {'fcm_token': AppVariables.fcmToken}),
          ),
      jsonConvert: loginResponseFromJson,
    );
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


  Future<void> logOut()
  async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
        ApiVariables.logout(),


      ),
      jsonConvert: (_){},
    );
  }

  Future<LoginResponse> updateProfile({
    required File image,
  })
  async {
    return wrapHandlingApi(
      tryCall:
          () async{
            final formData = FormData.fromMap({
              'profile_image_url': await MultipartFile.fromFile(
                image.path,
                filename: image.path.split('/').last,
              ),
            });
            return _baseApi.post(
        ApiVariables.updateProfile(),
        data:formData,
      );
          },
      jsonConvert: loginResponseFromJson,
    );
  }



  Future<void> deleteFCMToken() async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.post(
        ApiVariables.deleteFCMToken(),
      ),
      jsonConvert: (_) {},
    );
  }
}
