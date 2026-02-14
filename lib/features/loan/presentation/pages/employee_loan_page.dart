import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../data/models/loan_model.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/usecases/add_loan_usecase.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLoanSheet(context, theme),
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text(
          "سلفة جديدة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
      ).animate().scale(
        delay: 1000.ms,
        duration: 800.ms,
        curve: Curves.bounceOut,
      ),
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          if (state.getAllLoansData.isLoading) {
             return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }
          
          if (state.getAllLoansData.isFailed) { // Corrected: isFailed instead of isFaild
             return Center(child: Text(state.getAllLoansData.errorMessage, style: TextStyle(color: theme.colorScheme.error)));
          }

          final loans = state.getAllLoansData.data?.data ?? [];

          if (loans.isEmpty) {
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
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _buildLoanCard(loan, theme)
                  .animate()
                  .fadeIn(delay: (index * 150).ms)
                  .slideY(begin: 0.1, end: 0);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoanCard(LoanModel loan, ThemeData theme) {
    late Color statusColor;
    late String statusText;
    
    switch (loan.role) {
      case LoanStatus.unpaid:
        statusColor = Colors.red.shade600;
        statusText = "غير مسددة";
        break;
      case LoanStatus.partiallyPaid:
        statusColor = Colors.orange.shade800;
        statusText = "مسددة جزئياً";
        break;
      case LoanStatus.fullyPaid:
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
              "${NumberFormat.decimalPattern().format(loan.amount - loan.paidAmount)} ل.س",
              theme,
              isBold: true,
              valueColor: Colors.red.shade600,
            ),
            _buildDetailRow(
              "تاريخ الطلب:",
              DateFormat('yyyy-MM-dd').format(loan.date),
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

void _showAddLoanSheet(BuildContext context, ThemeData theme) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.cardColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
    ),
    builder: (context) => _AddLoanSheet(theme: theme),
  );
}

class _AddLoanSheet extends StatefulWidget {
  final ThemeData theme;

  const _AddLoanSheet({required this.theme});

  @override
  State<_AddLoanSheet> createState() => _AddLoanSheetState();
}

class _AddLoanSheetState extends State<_AddLoanSheet> {
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "إضافة سلفة جديدة",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),

          SizedBox(height: 16.h),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: "قيمة السلفة",
              suffixText: "ل.س",
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: _submit,
              child: Text(
                "حفظ السلفة",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  void _submit() {
    if (amountController.text.isNotEmpty) {
      final amount = int.tryParse(amountController.text) ?? 0;
      final loan = AddLoanParams(
        amount: amount,
        date: DateTime.now(),
      );
      context.read<LoanBloc>().add(AddLoanEvent(params: loan));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال طلب السلفة بنجاح"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
