import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/ model/get_unpaid_weeks.dart';
import '../../domain/usecases/post_payrecords_params.dart';
import '../../domain/usecases/update_payment_params.dart';
import '../bloc/PaymentAction/payment_action_bloc.dart';
import '../bloc/PaymentAction/payment_action_event.dart';
import '../bloc/PaymentAction/payment_action_state.dart';
import '../bloc/UnpaidWeeks/unpaid_weeks_bloc.dart';
import '../bloc/UnpaidWeeks/unpaid_weeks_event.dart';
import '../bloc/UnpaidWeeks/unpaid_weeks_state.dart';

class EmployeeDetailsPagePayments extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailsPagePayments({super.key, required this.employeeId});

  @override
  State<EmployeeDetailsPagePayments> createState() =>
      _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPagePayments> {
  @override
  void initState() {
    super.initState();
    context.read<UnpaidWeeksBloc>().add(LoadUnpaidWeeks(widget.employeeId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل المستحقات")),
      body: BlocBuilder<UnpaidWeeksBloc, UnpaidWeeksState>(
        builder: (context, state) {
          if (state is UnpaidWeeksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UnpaidWeeksError) {
            return Center(child: Text(state.message));
          } else if (state is UnpaidWeeksLoaded) {
            final response = state.response;
            return Column(
              children: [
                if (response.summary != null) _buildFinancialSummary(response.summary!, theme),
                Expanded(
                  child: ListView.builder(
                    itemCount: response.weeks.length,
                    itemBuilder: (context, index) {
                      final week = response.weeks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: ListTile(
                          title: Text("الفترة: ${week.weekRange}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.h),
                              Text("الساعات: نظامي (${week.totalRegularHours}) - إضافي (${week.totalOvertimeHours})"),
                              Text("المبلغ المستحق: ${week.estimatedAmount}\$", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _showPaymentDialog(context, week),
                            child: const Text("دفع"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildFinancialSummary(PaymentSummary summary, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _summaryRow("إجمالي المستحقات:", "${summary.grossTotal}\$", Colors.black87),
          _summaryRow("إجمالي الخصومات:", "${summary.discounts}\$", Colors.red),
          const Divider(),
          _summaryRow("صافي المبلغ المطلوب:", "${summary.netTotal}\$", theme.primaryColor, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, UnpaidWeeks week) {
    final TextEditingController amountController = TextEditingController(
      text: week.estimatedAmount.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<PaymentActionBloc>(),
          child: BlocListener<PaymentActionBloc, PaymentActionState>(
            listener: (context, state) {
              if (state is PaymentActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
                Navigator.pop(dialogContext);
                context.read<UnpaidWeeksBloc>().add(LoadUnpaidWeeks(widget.employeeId));
              }
              if (state is PaymentActionError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red));
              }
            },
            child: AlertDialog(
              title: const Text("تأكيد الدفع"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("سيتم دفع مستحقات الفترة: ${week.weekRange}"),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: "المبلغ المدفوع"),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("إلغاء")),
                ElevatedButton(
                  onPressed: () {
                    final double amountEntered = double.tryParse(amountController.text) ?? 0;
                    if (amountEntered <= 0) return;

                    context.read<PaymentActionBloc>().add(
                      ExecutePostPayment(
                        PostPayRecordsParams(
                          employeeId: int.parse(widget.employeeId),
                          attendanceIds: week.ids ?? [],
                          amountPaid: amountEntered,
                          paymentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        ),
                      ),
                    );
                  },
                  child: const Text("تأكيد"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
