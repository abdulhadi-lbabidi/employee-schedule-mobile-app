import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../../../core/unified_api/handling_api_manager.dart';

@lazySingleton
class FcmRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  FcmRemoteDataSource(this._baseApi);

  Future<void> updateFcmToken(String token) async {
    return wrapHandlingApi<void>(
      tryCall: () async => _baseApi.post(
        ApiVariables.updateFCMToken(),
        data: {'fcm_token': token},
      ),
      jsonConvert: (json) => null,
    );
  }
}
