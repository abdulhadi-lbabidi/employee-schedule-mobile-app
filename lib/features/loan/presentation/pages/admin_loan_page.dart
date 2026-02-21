import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../data/models/get_all_loane.dart';
import '../../data/models/loan_model.dart';
import '../bloc/loan_bloc.dart';
import '../../domain/entities/loan_entity.dart' hide LoanStatus;
import '../widget/accepted_loans_page.dart';

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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("إدارة السلف", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
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

          final  List<Loane>allLoans = state.getAllLoansData.data ?? [];

          // تصفية السلف المقبولة للعرض في الكارت العلوي
          final acceptedLoans = allLoans
              .where((l) =>
          l.status == LoanStatus.approved ||
              l.status == LoanStatus.completed ||
              l.status == LoanStatus.partially)
              .toList();
          // تصفية السلف الجديدة (التي تحتاج قرار)
          final pendingLoans = allLoans.where((l) => l.status == LoanStatus.waiting).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. كارت السلف المقبولة
                _buildSummaryCard(context, theme, acceptedLoans),

                SizedBox(height: 24.h),

                // عنوان القائمة
                Text(
                  "طلبات السلف الجديدة",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),

                // 2. قائمة الطلبات الجديدة
                if (pendingLoans.isEmpty)
                  _buildEmptyState()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingLoans.length,
                    itemBuilder: (context, index) {
                      return _buildPendingLoanItem(pendingLoans[index], theme);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // كارت الملخص العلوي
  Widget _buildSummaryCard(BuildContext context, ThemeData theme, List<Loane> accepted) {
    double totalAccepted = accepted.fold(0, (sum, item) => sum + item.amount);

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AcceptedLoansPage(loans: accepted))),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("إجمالي السلف المقبولة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.h),
                  Text("${NumberFormat.decimalPattern().format(totalAccepted)} \$",
                      style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Text("عدد السلف: ${accepted.length}", style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // ويدجت السلفة التي تنتظر القرار
  Widget _buildPendingLoanItem(Loane loan, ThemeData theme) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.1), child: const Icon(Icons.person, color: Colors.orange)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loan.employee.fullName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      Text(DateFormat('yyyy/MM/dd').format(loan.date), style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                    ],
                  ),
                ),
                Text("${loan.amount} \$", style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 16.sp)),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showActionDialog(context, "قبول", Colors.green, () {
                      context.read<LoanBloc>().add(ApproveLoanEvent(loanId: loan.id));
                    }),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text("قبول"),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showActionDialog(context, "رفض", Colors.red, () {
                      context.read<LoanBloc>().add(RejectLoanEvent(loanId: loan.id));
                    }),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text("رفض"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, String action, Color color, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        title: Text("$action الطلب"),
        content: Text("هل أنت متأكد من $action هذا الطلب؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
          TextButton(onPressed: () { onConfirm(); Navigator.pop(d); }, child: Text("تأكيد", style: TextStyle(color: color))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("لا توجد طلبات جديدة حالياً", style: TextStyle(color: Colors.grey))));
}