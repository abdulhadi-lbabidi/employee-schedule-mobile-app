// import '../model/login_response.dart';
// import 'auth_remote_data_source.dart';
//
// class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
//   @override
//   Future<LoginResponse> login({
//     required String username,
//     required String password,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 800));
//
//     // 1. حساب المدير
//     if (username == 'admin' && password == '123456') {
//       return LoginResponse(
//         success: true,
//         message: 'تم تسجيل الدخول بنجاح (حساب مدير تجريبي)',
//         token: 'mock_admin_token',
//         user: User(
//           id: 101,
//           username: 'admin',
//           email: 'admin@nouh-agency.com',
//           fullName: 'عبد الرحمن نوح',
//           role: 'admin',
//         ),
//       );
//     }
//
//     // 2. حساب الموظف
//     else if (username == 'user' && password == '123456') {
//       return LoginResponse(
//         success: true,
//         message: 'تم تسجيل الدخول بنجاح (حساب موظف تجريبي)',
//         token: 'mock_user_token',
//         user: User(
//           id: 102,
//           username: 'user',
//           email: 'user@nouh-agency.com',
//           fullName: 'أحمد محمد',
//           role: 'employee',
//         ),
//       );
//     }
//
//     else {
//       return LoginResponse(
//         success: false,
//         message: 'اسم المستخدم أو كلمة المرور غير صحيحة (التجريبي: admin أو user / 123456)',
//       );
//     }
//   }
//
//   @override
//   Future<bool> verifyToken(String token) async {
//     return true;
//   }
//
//   @override
//   Future<LoginResponse> register({
//     required String username,
//     required String password,
//     required String email,
//     required String fullName,
//     required String role,
//   }) async {
//     return LoginResponse(
//       success: true,
//       message: 'تم إنشاء حساب تجريبي بنجاح',
//       user: User(
//         id: DateTime.now().millisecondsSinceEpoch,
//         username: username,
//         email: email,
//         fullName: fullName,
//         role: role,
//       ),
//     );
//   }
// }
