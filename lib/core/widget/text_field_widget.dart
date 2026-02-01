// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../features/auth/presentation/bloc/password_visibility_cubit.dart';
// import '../../features/auth/presentation/bloc/password_visibility_state.dart';
//
// class TextFieldWidgetPassword extends StatelessWidget {
//   final String hinttext;
//   final String icon;
//   final TextEditingController controller;
//
//   const TextFieldWidgetPassword({
//     super.key,
//     required this.icon,
//     required this.hinttext,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     const border = OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(24)),
//       borderSide: BorderSide(color:Color.fromARGB(255, 229, 231, 235)),
//     );
//
//     return BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
//       builder: (context, state) {
//         final isHidden =
//             state is PasswordHidden || state is PasswordValidationError;
//         final errorText =
//             state is PasswordValidationError ? state.message : null;
//
//         return TextField(
//           controller: controller,
//           obscureText: isHidden,
//           onChanged: (value) {
//             context.read<PasswordVisibilityCubit>().validatePassword(value);
//           },
//           decoration: InputDecoration(
//             prefixIcon: Image.asset(icon, color:  Color.fromARGB(255, 161, 168, 176)),
//             hintText: hinttext,
//             errorText: errorText,
//             hintStyle: const TextStyle(color: Colors.grey),
//             filled: true,
//             fillColor: Color.fromARGB(255, 249, 250, 251),
//             enabledBorder: border,
//             focusedBorder: border,
//             errorBorder: border.copyWith(
//               borderSide: BorderSide(color: Colors.red),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 20,
//               horizontal: 16,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 isHidden ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey,
//               ),
//               onPressed: () {
//                 context.read<PasswordVisibilityCubit>().toggleVisibility();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
