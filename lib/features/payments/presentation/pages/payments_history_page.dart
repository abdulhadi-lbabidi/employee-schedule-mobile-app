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
  String? _selectedEmployeeName; // متغير لتخزين الموظف المختار

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
        actions: [
          // زر لإعادة ضبط التصفية
          if (_selectedEmployeeName != null)
            IconButton(
              icon: const Icon(Icons.filter_list_off),
              onPressed: () => setState(() => _selectedEmployeeName = null),
            ),
        ],
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

            // 1. استخراج قائمة فريدة بأسماء الموظفين للتصفية
            final allEmployees = state.payments
                .map((p) => p.employeeName.toString())
                .toSet()
                .toList();

            // 2. تصفية القائمة بناءً على الاختيار
            final filteredPayments = _selectedEmployeeName == null
                ? state.payments
                : state.payments
                .where((p) => p.employeeName.toString() == _selectedEmployeeName)
                .toList();

            return Column(
              children: [
                // 3. إضافة القائمة المنسدلة للتصفية
                _buildFilterDropdown(allEmployees, theme),

                Expanded(
                  child: filteredPayments.isEmpty
                      ? const Center(child: Text("لا توجد نتائج لهذا الموظف"))
                      : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredPayments.length,
                    itemBuilder: (context, index) {
                      final payment = filteredPayments[index];
                      return _buildPaymentCard(payment, theme);
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

  // وجت بناء القائمة المنسدلة
  Widget _buildFilterDropdown(List<String> employeeNames, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedEmployeeName,
          hint: const Text("تصفية حسب اسم الموظف"),
          isExpanded: true,
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text("عرض الكل"),
            ),
            ...employeeNames.map((name) => DropdownMenuItem(
              value: name,
              child: Text(_formatName(name)),
            )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedEmployeeName = value;
            });
          },
        ),
      ),
    );
  }

  // دالة مساعدة لتنسيق الاسم (نفس المنطق المستخدم في البطاقة)
  String _formatName(String rawName) {
    return rawName.split('.').last.replaceAll('_', ' ');
  }

  Widget _buildPaymentCard(dynamic payment, ThemeData theme) {
    // 🔹 تعديل منطق التحقق: نعتبرها مكتملة إذا كان النص يحتوي على PAID أو إذا كان المتبقي 0
    final double remaining = double.tryParse(payment.remainingAmount.toString()) ?? 0.0;
    bool isPaid = payment.status.toString().toUpperCase().contains("PAID") || remaining <= 0;

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
                  _formatName(payment.employeeName.toString()),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    isPaid ? "مكتملة" : "غير مكتملة",
                    style: TextStyle(color: isPaid ? Colors.green : Colors.orange, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            const Divider(),
            _rowInfo("إجمالي المبلغ:", "${payment.totalAmount}\$"),
            _rowInfo("المبلغ المدفوع:", "${payment.amountPaid}\$", color: Colors.green),
            _rowInfo("المتبقي:", "${payment.remainingAmount} \$", color: isPaid ? Colors.green : Colors.red), // تغيير اللون للأخضر إذا كان 0
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
