import 'package:flutter/material.dart';

class OnButton extends StatelessWidget {
  final String textBoutton;
  final double widthSize;
  final Function() function;

  OnButton({super.key, required this.function, required this.textBoutton, required this.widthSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF179D95), // نفس لون الخلفية في الصورة
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: Size(widthSize, 60),
      ),
      child: Text(
        textBoutton,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
