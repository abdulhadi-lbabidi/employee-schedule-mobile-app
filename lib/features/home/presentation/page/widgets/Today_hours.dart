import 'package:flutter/material.dart';

class TodayHours extends StatelessWidget {
  const TodayHours({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      "Item 1",
      "Item 2",
      "Item 3",
      "Item 4",
    ];
    return Card(
      color:  Color.fromARGB(255, 84, 80, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الساعات المطلوبة :',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '8 ساعات',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.only(bottom: 10,right: 14.0),
            child: Text(
              '-----  :الساعات متبقية ',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
