import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../data/models/loan_model.dart';
import '../bloc/loan_bloc.dart';
import '../../domain/entities/loan_entity.dart';

class AdminLoanPage extends StatefulWidget {
  const AdminLoanPage({super.key});

  @override
  State<AdminLoanPage> createState() => _AdminLoanPageState();
}

class _AdminLoanPageState extends State<AdminLoanPage> {
  @override
  void initState() {
    super.initState();
    context.read<LoanBloc>().add(GetAllLoansEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("طلبات السلف", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => context.read<LoanBloc>().add(GetAllLoansEvent()),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          if (state.getAllLoansData.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final loans = state.getAllLoansData.data?.data ?? [];
          
          if (loans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.money_off, size: 80.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  const Text("لا توجد طلبات سلف حالياً", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _buildLoanCard(loan, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoanCard(LoanModel loan, ThemeData theme) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.primaryColor),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.employeeName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      Text(
                        DateFormat('yyyy/MM/dd').format(loan.date),
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${NumberFormat.decimalPattern().format(loan.amount)} \$",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "المسدد: ${loan.paidAmount}",
                      style: TextStyle(fontSize: 10.sp, color: Colors.blueGrey),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                if (loan.role == LoanStatus.unpaid) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showActionDialog(context, "قبول السلفة", "هل أنت متأكد من قبول هذه السلفة؟", () {
                        context.read<LoanBloc>().add(ApproveLoanEvent(loanId: loan.id));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: const Text("قبول"),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showActionDialog(context, "رفض السلفة", "هل أنت متأكد من رفض هذه السلفة؟", () {
                        context.read<LoanBloc>().add(RejectLoanEvent(loanId: loan.id));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: const Text("رفض"),
                  ),
                ),
                ],
                if (loan.role != LoanStatus.unpaid) 
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showPayDialog(context, loan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: const Text("تسديد دفعة"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );
  }

  void _showPayDialog(BuildContext context, LoanModel loan) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تسديد سلفة"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "المبلغ المراد تسديده", suffixText: "\$"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                context.read<LoanBloc>().add(PayLoanEvent(loanId: loan.id, amount: amount));
                Navigator.pop(context);
              }
            },
            child: const Text("تسديد"),
          ),
        ],
      ),
    );
  }
}
