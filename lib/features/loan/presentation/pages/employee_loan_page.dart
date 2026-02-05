import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/features/loan/data/models/get_loan_response.dart';
import '../../domain/entities/loan_entity.dart';
import '../bloc/loan_bloc.dart';

class EmployeeLoanPage extends StatefulWidget {
  const EmployeeLoanPage({super.key});

  @override
  State<EmployeeLoanPage> createState() => _EmployeeLoanPageState();
}

class _EmployeeLoanPageState extends State<EmployeeLoanPage> {
  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  void _loadLoans() {
    context.read<LoanBloc>().add(GetAllLoansEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          return state.getAllLoansData.builder(
            onSuccess: (_) {
              if (state.getAllLoansData.data!.data!.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد لديك سلف حالياً",
                    style: TextStyle(
                      color: theme.disabledColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                itemCount: state.getAllLoansData.data!.data!.length,
                itemBuilder: (context, index) {
                  final loan = state.getAllLoansData.data!.data![index];
                  return _buildLoanCard(loan, theme)
                      .animate()
                      .fadeIn(delay: (index * 150).ms)
                      .slideY(begin: 0.1, end: 0);
                },
              );
            },
            loadingWidget: Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            ),
            failedWidget: Center(
              child: Text(
                state.getAllLoansData.errorMessage,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoanCard(LoanModel loan, ThemeData theme) {
    late Color statusColor;
    late String statusText;
    switch (loan.role) {
      case 'waiting':
        statusColor = Colors.red.shade600;
        statusText = "غير مسددة";
        break;
      case 'partially':
        statusColor = Colors.orange.shade800;
        statusText = "مسددة جزئياً";
        break;
      case 'compoleted':
        statusColor = Colors.green.shade700;
        statusText = "مسددة بالكامل";
        break;
    }

    return Card(
      color: theme.cardColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تفاصيل السلفة",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildDetailRow(
              "القيمة الكلية:",
              "${NumberFormat.decimalPattern().format(loan.amount)} ل.س",
              theme,
            ),
            _buildDetailRow(
              "المبلغ المسدد:",
              "${NumberFormat.decimalPattern().format(loan.paidAmount)} ل.س",
              theme,
            ),
            _buildDetailRow(
              "المبلغ المتبقي:",
              "${NumberFormat.decimalPattern().format(loan.amount! - (loan.paidAmount ?? 0))} ل.س",
              theme,
              isBold: true,
              valueColor: Colors.red.shade600,
            ),
            // _buildDetailRow("سبب السلفة:", loan.reason, theme),
            _buildDetailRow(
              "تاريخ الطلب:",
              DateFormat('yyyy-MM-dd').format(loan.date ?? DateTime.now()),
              theme,
            ),

            Divider(color: theme.dividerColor.withOpacity(0.1), height: 30.h),
            Text(
              "تأثير السلفة على الراتب:",
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "سيتم خصم المبلغ المتبقي من مستحقاتك المالية القادمة حسب جدول التسديد المتفق عليه.",
              style: TextStyle(
                color: theme.disabledColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    ThemeData theme, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color:
                  valueColor ??
                  (isBold
                      ? theme.textTheme.bodyLarge?.color
                      : theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
