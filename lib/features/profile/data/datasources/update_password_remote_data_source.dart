import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../../../core/unified_api/handling_api_manager.dart';
import '../models/update_profile_response_model.dart';

@lazySingleton
class UpdatePasswordRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  UpdatePasswordRemoteDataSource(this._baseApi);

  Future<UpdateProfileResponseModel> updatePassword(Map<String, dynamic> params) async {
    return wrapHandlingApi<UpdateProfileResponseModel>(
      tryCall: () async => _baseApi.post(
        ApiVariables.updatePassword(),
        data: params,
      ),
      jsonConvert: (json) => UpdateProfileResponseModel.fromJson(json),
    );
  }
}
