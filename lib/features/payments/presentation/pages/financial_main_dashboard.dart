import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/payments/presentation/pages/payments_history_page.dart';

import 'AdminFinancePage.dart';
 // واجهة المستحقات التي قمت ببرمجتها سابقاً

class FinancialMainDashboard extends StatelessWidget {
  const FinancialMainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("الإدارة المالية"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ملخص العمليات",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              // بطاقة المستحقات المالية
              _buildReportCard(
                context,
                title: "كشف المستحقات",
                subtitle: "عرض مستحقات الموظفين والرواتب غير المدفوعة",
                icon: Icons.account_balance_wallet_rounded,
                color: Colors.indigo,
                onTap: () {
                  // الانتقال لواجهة المستحقات (التي برمجناها أولاً)
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancialDashboard()));
                },
              ),
              SizedBox(height: 15.h),
              // بطاقة سجل المدفوعات
              _buildReportCard(
                context,
                title: "سجل المدفوعات",
                subtitle: "عرض كافة الحوالات والمدفوعات التي تمت مسبقاً",
                icon: Icons.history_rounded,
                color: Colors.teal,
                onTap: () {
                  // الانتقال لواجهة سجل الدفع (التي تحتوي على الـ Post/Put)
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentsHistoryPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(icon, color: Colors.white, size: 30.sp),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: color.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 18.sp, color: color),
          ],
        ),
      ),
    );
  }
}