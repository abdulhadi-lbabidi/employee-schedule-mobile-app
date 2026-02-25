import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/get_all_loane.dart';
import '../bloc/loan_bloc.dart';

class AcceptedLoansPage extends StatefulWidget {
  final List<Loane> loans;
  const AcceptedLoansPage({super.key, required this.loans});

  @override
  State<AcceptedLoansPage> createState() => _AcceptedLoansPageState();
}

class _AcceptedLoansPageState extends State<AcceptedLoansPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocListener<LoanBloc, LoanState>(
      listener: (context, state) {
        // إذا نجح الدفع (أي تم تحديث البيانات بنجاح)، سنقوم بتحديث القائمة المعروضة
        // ملاحظة: الـ Bloc سيقوم بإرسال GetAllLoansEvent تلقائياً كما عدلناه سابقاً
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("السلف المقبولة"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: BlocBuilder<LoanBloc, LoanState>(
          builder: (context, state) {
            // نستخدم البيانات من الـ Bloc إذا كانت موجودة لضمان التحديث اللحظي
            final List<Loane> displayLoans = state.getAllLoansData.isSuccess 
                ? (state.getAllLoansData.data ?? widget.loans)
                : widget.loans;

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: displayLoans.length,
              itemBuilder: (context, index) {
                final loan = displayLoans[index];
                final double totalAmount = loan.amount ?? 0;
                final double paidAmount = loan.paidAmount ?? 0;
                final double remaining = totalAmount - paidAmount;
                final bool isFullyPaid = remaining <= 0;

                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    isThreeLine: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isFullyPaid ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFullyPaid ? Icons.done_all_rounded : Icons.payments_rounded,
                        color: isFullyPaid ? Colors.green : Colors.blue,
                      ),
                    ),
                    title: Text(
                      loan.employee?.fullName?.replaceAll('_', ' ') ?? "موظف",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "المتبقي: ${remaining.toStringAsFixed(0)} \$",
                          style: TextStyle(fontSize: 12.sp, color: remaining > 0 ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "إجمالي المسدد: ${paidAmount.toStringAsFixed(0)} \$ من ${totalAmount.toStringAsFixed(0)} \$",
                          style: TextStyle(fontSize: 11.sp, color: Colors.green.shade700, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isFullyPaid)
                          ElevatedButton(
                            onPressed: () => _showPayDialog(context, loan, remaining),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              minimumSize: Size(60.w, 30.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            ),
                            child: Text("دفع", style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                          )
                        else
                          const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showPayDialog(BuildContext context, Loane loan, double remaining) {
    final controller = TextEditingController(text: remaining.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: const Text("تسديد سلفة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("المبلغ المتبقي حالياً: ${remaining.toStringAsFixed(0)} \$"),
            SizedBox(height: 15.h),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "المبلغ المراد دفعه",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dContext), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0 && amount <= remaining) {
                // استدعاء البلوك لتنفيذ عملية الدفع
                context.read<LoanBloc>().add(PayLoanEvent(loanId: loan.id!, amount: amount));
                Navigator.pop(dContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("جاري معالجة الدفع..."), backgroundColor: Colors.blue),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("المبلغ غير صحيح"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("تأكيد الدفع"),
          ),
        ],
      ),
    );
  }
}
