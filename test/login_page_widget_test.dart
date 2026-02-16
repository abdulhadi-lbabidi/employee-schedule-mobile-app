// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:untitled8/features/auth/presentation/presentation/login_page.dart';
// import 'package:untitled8/features/auth/presentation/bloc/login_Cubit/login_cubit.dart';
// import 'package:untitled8/features/auth/data/repository/login_repo.dart';
// import 'package:untitled8/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:untitled8/features/auth/data/model/login_response.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class ManualFakeSS extends FlutterSecureStorage {
//   @override
//   Future<void> write({
//     required String key,
//     required String? value,
//     iOptions,
//     aOptions,
//     lOptions,
//     mOptions,
//     wOptions,
//     webOptions,
//   }) async {}
//
//   @override
//   Future<String?> read({
//     required String key,
//     iOptions,
//     aOptions,
//     lOptions,
//     mOptions,
//     wOptions,
//     webOptions,
//   }) async => null;
// }
//
// class ManualFakeDS implements AuthRemoteDataSource {
//   @override
//   Future<LoginResponse> login({required String username, required String password}) async => LoginResponse(success: true, message: "OK");
//   @override
//   Future<LoginResponse> register({required String username, required String password, required String email, required String fullName, required String role}) async => LoginResponse(success: true, message: "OK");
//   @override
//   Future<bool> verifyToken(String token) async => true;
// }
//
// class ManualFakeAuthRepo extends AuthRepository {
//   ManualFakeAuthRepo() : super(remoteDataSource: ManualFakeDS(), secureStorage: ManualFakeSS());
// }
//
// void main() {
//   testWidgets('اختبار وجود عناصر صفحة تسجيل الدخول', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       ScreenUtilInit(
//         designSize: const Size(360, 690),
//         builder: (context, child) => MaterialApp(
//           home: BlocProvider(
//             create: (context) => LoginCubit(repository: ManualFakeAuthRepo()),
//             child: const LoginPage(),
//           ),
//         ),
//       ),
//     );
//
//     expect(find.byIcon(Icons.lock_outline), findsWidgets);
//     expect(find.byType(TextField), findsNWidgets(2));
//     expect(find.byType(ElevatedButton), findsOneWidget);
//     expect(find.text('تسجيل الدخول'), findsWidgets);
//   });
// }
