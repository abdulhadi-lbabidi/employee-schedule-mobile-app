import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/get_all_loane.dart';
import '../../data/models/loan_model.dart';

class AcceptedLoansPage extends StatelessWidget {
  final List<Loane> loans;
  const AcceptedLoansPage({super.key, required this.loans});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("السلف المقبولة")),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.check, color: Colors.green)),
              title: Text(loan.employee.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(loan.date)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${loan.amount} \$", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                  Text("المسدد: ${loan.paidAmount}", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}