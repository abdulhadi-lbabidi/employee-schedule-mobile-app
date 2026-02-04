import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../hive_service.dart';
import 'injection.config.dart';


final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<GetIt> configureInjection() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

// ✅ HiveService
  final hiveService = HiveService();
  await hiveService.init(); // تأكد من تهيئة Hive
  sl.registerSingleton<HiveService>(hiveService);
  return $initGetIt(sl);
}


@module
abstract class InjectableModule {
  @singleton
  Dio get dio => Dio();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

}
