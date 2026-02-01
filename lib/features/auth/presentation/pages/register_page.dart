// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// import '../../data/repository/login_repo.dart';
// import '../bloc/auth_Cubit.dart';
// import '../bloc/auth_state.dart';
// import '../bloc/login_Cubit/login_cubit.dart';
//
// class SignUpPage extends StatelessWidget {
//   final AuthRepository authRepository;
//   SignUpPage({super.key, required this.authRepository});
//
//
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => LoginCubit(repository: authRepository),
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromARGB(255, 79, 77, 77),
//                   Color.fromARGB(255, 42, 38, 38)
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: Center(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24),
//                   child: BlocConsumer<AuthCubit, AuthState>(
//                     listener: (context, state) {
//                       if (state is AuthSuccess) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(state.message),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         // العودة لصفحة تسجيل الدخول
//                         Navigator.pop(context);
//                       } else if (state is AuthError) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(state.message),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       final cubit = context.read<AuthCubit>();
//                       final isLoading = state is AuthLoading;
//
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // أيقونة التطبيق
//                           Container(
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 20,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.person_add_outlined,
//                               size: 60,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//
//                           // عنوان الصفحة
//                           const Text(
//                             'إنشاء حساب جديد',
//                             style: TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 40),
//
//                           // بطاقة الحقول
//                           Card(
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(24),
//                               child: Column(
//                                 children: [
//                                   // حقل اسم المستخدم
//                                   TextField(
//                                     controller: _usernameController,
//                                     decoration: InputDecoration(
//                                       labelText: 'اسم المستخدم',
//                                       prefixIcon: const Icon(
//                                         Icons.person_outline,
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       filled: true,
//                                       fillColor: Colors.grey.shade50,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//
//                                   // حقل كلمة المرور
//                                   BlocBuilder<AuthCubit, AuthState>(
//                                     builder: (context, state) {
//                                       return TextField(
//                                         controller: _passwordController,
//                                         obscureText: !cubit.isPasswordVisible,
//                                         decoration: InputDecoration(
//                                           labelText: 'كلمة المرور',
//                                           hintText: '8 أحرف على الأقل',
//                                           prefixIcon: const Icon(
//                                             Icons.lock_outline,
//                                           ),
//                                           suffixIcon: IconButton(
//                                             icon: Icon(
//                                               cubit.isPasswordVisible
//                                                   ? Icons.visibility
//                                                   : Icons.visibility_off,
//                                             ),
//                                             onPressed: () {
//                                               cubit.togglePasswordVisibility();
//                                             },
//                                           ),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                           filled: true,
//                                           fillColor: Colors.grey.shade50,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   const SizedBox(height: 20),
//
//                                   // حقل تأكيد كلمة المرور
//                                   BlocBuilder<AuthCubit, AuthState>(
//                                     builder: (context, state) {
//                                       return TextField(
//                                         controller: _confirmPasswordController,
//                                         obscureText:
//                                             !cubit.isConfirmPasswordVisible,
//                                         decoration: InputDecoration(
//                                           labelText: 'تأكيد كلمة المرور',
//                                           prefixIcon: const Icon(
//                                             Icons.lock_outline,
//                                           ),
//                                           suffixIcon: IconButton(
//                                             icon: Icon(
//                                               cubit.isConfirmPasswordVisible
//                                                   ? Icons.visibility
//                                                   : Icons.visibility_off,
//                                             ),
//                                             onPressed: () {
//                                               cubit
//                                                   .toggleConfirmPasswordVisibility();
//                                             },
//                                           ),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                           filled: true,
//                                           fillColor: Colors.grey.shade50,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   const SizedBox(height: 30),
//
//                                   // زر إنشاء الحساب
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 50,
//                                     child: ElevatedButton(
//                                       onPressed: isLoading
//                                           ? null
//                                           : () {
//                                               cubit.signUp(
//                                                 _usernameController.text.trim(),
//                                                 _passwordController.text,
//                                                 _confirmPasswordController.text,
//                                               );
//                                             },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.blue,
//                                         foregroundColor: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         elevation: 5,
//                                       ),
//                                       child: isLoading
//                                           ? const SizedBox(
//                                               height: 20,
//                                               width: 20,
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2,
//                                               ),
//                                             )
//                                           : const Text(
//                                               'إنشاء حساب',
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//
//                           // رابط تسجيل الدخول
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'لديك حساب بالفعل؟',
//                                 style: TextStyle(color: Colors.white70),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text(
//                                   'تسجيل الدخول',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
