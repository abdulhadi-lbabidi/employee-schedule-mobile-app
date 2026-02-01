import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextInputType? textInputType;
  final String hinttext;
  final String icon;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final TextEditingController controller;

  const TextFieldWidget({
    super.key,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.icon,
    required this.hinttext,
    required this.controller,required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      borderSide: BorderSide(color:  Color.fromARGB(255, 229, 231, 235)),
    );

    return TextField(
      keyboardType:textInputType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Image.asset(icon, color: Color.fromARGB(255, 161, 168, 176)),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor:Color.fromARGB(255, 249, 250, 251),
        enabledBorder: border,
        focusedBorder: border,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        // suffixIcon: IconButton(
        //   icon: icons(
        //     obscureText ? Icons.visibility_off : Icons.visibility,
        //     color: Colors.grey,
        //   ),
        //   onPressed: onToggleVisibility,
        // ),
      ),
    );
  }
}
