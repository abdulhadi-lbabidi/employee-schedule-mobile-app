import 'package:flutter_test/flutter_test.dart';
import 'package:untitled8/features/auth/presentation/bloc/login_Cubit/login_cubit.dart';
import 'package:untitled8/features/auth/presentation/bloc/login_Cubit/login_state.dart';
import 'package:untitled8/features/auth/data/repository/login_repo.dart';
import 'package:untitled8/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:untitled8/features/auth/data/model/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManualFakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    iOptions,
    aOptions,
    lOptions,
    mOptions,
    wOptions,
    webOptions,
  }) async {
    if (value != null) _storage[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
    iOptions,
    aOptions,
    lOptions,
    mOptions,
    wOptions,
    webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    iOptions,
    aOptions,
    lOptions,
    mOptions,
    wOptions,
    webOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<bool> containsKey({
    required String key,
    iOptions,
    aOptions,
    lOptions,
    mOptions,
    wOptions,
    webOptions,
  }) async {
    return _storage.containsKey(key);
  }
}

class FakeAuthDataSource implements AuthRemoteDataSource {
  bool shouldSucceed = true;

  @override
  Future<LoginResponse> login({required String username, required String password}) async {
    if (shouldSucceed) {
      return LoginResponse(
        success: true, 
        message: "نجاح", 
        // 🔹 تصحيح: الـ id رقمي، وحذف معامل image غير الموجود
        user: User(
          id: 1, 
          username: "test", 
          role: "admin", 
          fullName: "Test User", 
          email: "test@test.com",
        )
      );
    }
    return LoginResponse(success: false, message: "فشل");
  }

  @override
  Future<bool> verifyToken(String token) async => true;

  @override
  Future<LoginResponse> register({required String username, required String password, required String email, required String fullName, required String role}) async {
    return LoginResponse(success: true, message: "تم التسجيل");
  }
}

void main() {
  late LoginCubit loginCubit;
  late AuthRepository repo;
  late FakeAuthDataSource fakeDS;

  setUp(() {
    fakeDS = FakeAuthDataSource();
    repo = AuthRepository(
      remoteDataSource: fakeDS,
      secureStorage: ManualFakeSecureStorage(),
    );
    loginCubit = LoginCubit(repository: repo);
  });

  group('LoginCubit Tests', () {
    test('الحالة الابتدائية هي LoginInitial', () {
      expect(loginCubit.state, const LoginInitial());
    });

    test('إصدار [AuthLoading, AuthSuccess] عند النجاح', () async {
      fakeDS.shouldSucceed = true;
      final expected = [const AuthLoading(), isA<AuthSuccess>()];
      expectLater(loginCubit.stream, emitsInOrder(expected));
      await loginCubit.login(username: "user", password: "123");
    });
  });
}
