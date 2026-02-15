import 'package:dartz/dartz.dart' as emp;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'EmployeeDetailsPage.dart';

class FinancialDashboard extends StatelessWidget {
  const FinancialDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المستحقات المالية', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // --- الكرت الأول: الإحصائيات ---
            _buildStatisticsCard(),

            SizedBox(height: 20.h),

            Align(
              alignment: Alignment.centerRight,
              child: Text("قائمة الموظفين", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),

            SizedBox(height: 10.h),

            // --- قائمة الموظفين ---
            Expanded(
              child: ListView.builder(
                itemCount: 10, // مثال لعدد الموظفين
                itemBuilder: (context, index) {
                  return _buildEmployeeItem(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت كرت الإحصائيات
  Widget _buildStatisticsCard() {
    return Card(
      color: Colors.indigo.shade700,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem("الموظفين", "25", Icons.people),
            Container(width: 1.w, height: 50.h, color: Colors.white24),
            _buildStatItem("إجمالي الرواتب", "150,000\$", Icons.monetization_on),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.sp),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ودجت عنصر الموظف في القائمة
  Widget _buildEmployeeItem(BuildContext context, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)), // أنيميشن بسيط يتأخر حسب الترتيب
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ListTile(
          leading: CircleAvatar(child: Text("${index + 1}")),
          title: Text("موظف رقم ${index + 1}", style: TextStyle(fontSize: 16.sp)),
          subtitle: Text("إجمالي المستحقات: 5,000\$", style: TextStyle(fontSize: 14.sp)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // الانتقال لصفحة التفاصيل
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmployeeDetailsPage(employeeId: emp.id.toString())),
            );
          },
        ),
      ),
    );
  }
}