import 'package:flutter/material.dart';

class ClassOnnoardingScrren extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const ClassOnnoardingScrren({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام LayoutBuilder و MediaQuery لجعل الصفحة متجاوبة
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = constraints.maxHeight;
        final double screenWidth = constraints.maxWidth;
        final bool isSmallScreen = screenHeight < 600;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // جعل حجم الصورة متناسب مع طول الشاشة
                  Image.asset(
                    image,
                    height: screenHeight * 0.4,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 40),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 20),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // مساحة إضافية في الأسفل لضمان عدم تداخل المحتوى مع العناصر الثابتة (Indicator & Buttons)
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
