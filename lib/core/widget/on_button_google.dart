import 'package:flutter/material.dart';

class OnButtonGoogle extends StatelessWidget {
  final String textBoutton;
  final String imageBoutton;
  final Function() function;

  OnButtonGoogle({
    super.key,
    required this.function,
    required this.textBoutton,
    required this.imageBoutton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 357,
      height: 60,
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // نفس لون الخلفية في الصورة
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 40, height: 40, child: Image.asset(imageBoutton)),
            Expanded(
              child: Center(
                child: Text(
                  textBoutton,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
