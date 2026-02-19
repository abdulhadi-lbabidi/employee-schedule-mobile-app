import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/All-Payments/all_payments_bloc.dart';
import '../bloc/All-Payments/all_payments_event.dart';
import '../bloc/All-Payments/all_payments_state.dart';


class PaymentsHistoryPage extends StatefulWidget {
  const PaymentsHistoryPage({super.key});

  @override
  State<PaymentsHistoryPage> createState() => _PaymentsHistoryPageState();
}

class _PaymentsHistoryPageState extends State<PaymentsHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<AllPaymentsBloc>().add(FetchAllPayments());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل المدفوعات الكامل"),
        centerTitle: true,
      ),
      body: BlocBuilder<AllPaymentsBloc, AllPaymentsState>(
        builder: (context, state) {
          if (state is AllPaymentsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllPaymentsError) {
            return Center(child: Text(state.message));
          } else if (state is AllPaymentsLoaded) {
            if (state.payments.isEmpty) {
              return const Center(child: Text("لا توجد عمليات دفع مسجلة"));
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.payments.length,
              itemBuilder: (context, index) {
                final payment = state.payments[index];
                return _buildPaymentCard(payment, theme);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPaymentCard(dynamic payment, ThemeData theme) {
    bool isPaid = payment.status.toString().contains("PAID");

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  payment.employeeName.toString().split('.').last.replaceAll('_', ' '),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    isPaid ? "مكتمل" : "معلق",
                    style: TextStyle(color: isPaid ? Colors.green : Colors.orange, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            const Divider(),
            _rowInfo("إجمالي المبلغ:", "${payment.totalAmount}\$"),
            _rowInfo("المبلغ المدفوع:", "${payment.amountPaid}\$", color: Colors.green),
            _rowInfo("المتبقي:", "${payment.remainingAmount} \$", color: Colors.red),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("بواسطة: ${payment.adminName.toString().split('.').last.replaceAll('_', ' ')}",
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                Text(payment.paymentDate.toString().split('.').last.replaceAll('THE_', '').replaceAll('_', '-'),
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13.sp)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14.sp)),
        ],
      ),
    );
  }
}