import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // جلب البيانات عند فتح الصفحة
    context.read<UnpaidWeeksBloc>().add(LoadUnpaidWeeks(widget.employeeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل المستحقات")),
      body: BlocBuilder<UnpaidWeeksBloc, UnpaidWeeksState>(
        builder: (context, state) {
          if (state is UnpaidWeeksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UnpaidWeeksError) {
            return Center(child: Text(state.message));
          } else if (state is UnpaidWeeksLoaded) {
            return ListView.builder(
              itemCount: state.weeks.length,
              itemBuilder: (context, index) {
                final week = state.weeks[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("الفترة: ${week.weekRange}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("الساعات الاساسية: ${week.totalRegularHours}"),
                        Text("الساعات الاضافية : ${week.totalOvertimeHours}"),
                        SizedBox(height: 2,),
                        Text("المبلغ المقدر: ${week.estimatedAmount}\$"),



                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // هنا نفتح Dialog لعملية الدفع باستخدام PostPayRecordsUseCase
                        _showPaymentDialog(context, week);
                      },
                      child: const Text("دفع"),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(dialogContext); // إغلاق الـ Dialog
                // تحديث القائمة بعد الدفع
                context.read<UnpaidWeeksBloc>().add(
                  LoadUnpaidWeeks(widget.employeeId),
                );
              }
              if (state is PaymentActionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: AlertDialog(
              title: const Text("تأكيد الدفع"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("سيتم دفع مستحقات الفترة: ${week.weekRange}"),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: "المبلغ المدفوع",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("إلغاء"),
                ),
                BlocBuilder<PaymentActionBloc, PaymentActionState>(
                  builder: (context, state) {
                    if (state is PaymentActionLoading)
                      return const CircularProgressIndicator();
                    return // ... داخل الـ AlertDialog في قسم actions
                      ElevatedButton(
                        onPressed: () {
                          final double totalEstimated = week.estimatedAmount ?? 0;
                          final double amountEntered = double.tryParse(amountController.text) ?? 0;

                          if (amountEntered <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("يرجى إدخال مبلغ صحيح")),
                            );
                            return;
                          }

                          // المنطق البرمجي لاختيار العملية المناسبة
                          if (amountEntered < totalEstimated) {
                            // 1. حالة المبلغ الجزئي (تقسيط): نستخدم Update
                            // ملاحظة: تأكد أن الـ API يدعم التعديل دون وجود معرف دفع مسبق أو قم بتمرير المعرف المناسب
                            context.read<PaymentActionBloc>().add(
                              ExecuteUpdatePayment(
                                widget.employeeId, // أو المعرف المطلوب للـ API
                                UpdatePaymentParams(
                                  paymentId: widget.employeeId,
                                 // totalAmount: totalEstimated,
                                  attendanceIds: week.ids ?? [],
                                  amountPaid: amountEntered,
                                  paymentDate:DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                ),
                              ),
                            );
                          } else {
                            // 2. حالة المبلغ الكامل (أو أكثر): نستخدم Post
                            context.read<PaymentActionBloc>().add(
                              ExecutePostPayment(
                                PostPayRecordsParams(
                                  employeeId: int.parse(widget.employeeId),
                                  attendanceIds: week.ids ?? [],
                                 // totalAmount: totalEstimated,
                                  amountPaid: amountEntered,
                                  paymentDate:DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text("تأكيد"),
                      );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
