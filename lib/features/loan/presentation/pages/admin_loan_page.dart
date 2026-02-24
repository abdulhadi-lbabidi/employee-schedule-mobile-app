import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/get_all_loane.dart';
import '../bloc/loan_bloc.dart';
import '../../domain/entities/loan_entity.dart' hide LoanStatus;
import '../widget/accepted_loans_page.dart';

class AdminLoanPage extends StatefulWidget {
  const AdminLoanPage({super.key});

  @override
  State<AdminLoanPage> createState() => _AdminLoanPageState();
}

class _AdminLoanPageState extends State<AdminLoanPage> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    _refreshLoans();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _animate = true);
    });
  }

  void _refreshLoans() {
    context.read<LoanBloc>().add(GetAllLoansEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.9),
        title: Text(
          "إدارة السلف",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: _refreshLoans,
              icon: Icon(
                Icons.refresh_rounded,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          if (state.getAllLoansData.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final List<Loane> allLoans =
              state.getAllLoansData.data ?? [];

          final acceptedLoans = allLoans
              .where((l) =>
          l.status == LoanStatus.approved ||
              l.status == LoanStatus.completed ||
              l.status == LoanStatus.partially)
              .toList();

          final pendingLoans = allLoans
              .where((l) => l.status == LoanStatus.waiting)
              .toList();

          return RefreshIndicator(
            onRefresh: () async => _refreshLoans(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SUMMARY CARD
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    offset:
                    _animate ? Offset.zero : const Offset(0, 0.15),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: _animate ? 1 : 0,
                      child: _buildSummaryCard(
                        context,
                        theme,
                        acceptedLoans,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  /// TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fiber_new_rounded,
                            color: Colors.orange,
                            size: 18.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "طلبات جديدة",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      if (pendingLoans.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius:
                            BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "${pendingLoans.length} طلبات",
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  /// LIST
                  if (pendingLoans.isEmpty)
                    _buildEmptyState(theme)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: pendingLoans.length,
                      itemBuilder: (context, index) {
                        return AnimatedSlide(
                          duration: Duration(
                              milliseconds: 300 + index * 80),
                          offset: _animate
                              ? Offset.zero
                              : const Offset(0, 0.1),
                          child: AnimatedOpacity(
                            duration: Duration(
                                milliseconds: 300 + index * 80),
                            opacity: _animate ? 1 : 0,
                            child: _buildPendingLoanItem(
                              pendingLoans[index],
                              theme,
                            ),
                          ),
                        );
                      },
                    ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// SUMMARY CARD
  Widget _buildSummaryCard(
      BuildContext context,
      ThemeData theme,
      List<Loane> accepted,
      ) {
    final total = accepted.fold<double>(
      0,
          (sum, l) => sum + (l.amount ?? 0),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AcceptedLoansPage(loans: accepted),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "إجمالي السلف المقبولة",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "${NumberFormat.decimalPattern().format(total)} \$",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 14.h),
            Divider(color: Colors.white24),
            SizedBox(height: 8.h),
            Text(
              "عرض الكل (${accepted.length})",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// PENDING ITEM
  Widget _buildPendingLoanItem(Loane loan, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final empName =
        loan.employee?.fullName?.replaceAll('_', ' ') ??
            "موظف غير معروف";

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: theme.dividerColor.withOpacity(
            isDark ? 0.15 : 0.06,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor:
                  Colors.orange.withOpacity(0.15),
                  child: Text(
                    empName.characters.first,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        empName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "طلب سلفة جديد",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                    theme.primaryColor.withOpacity(0.1),
                    borderRadius:
                    BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    "${loan.amount?.toStringAsFixed(0)} \$",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon:
                    const Icon(Icons.close_rounded),
                    label: const Text("رفض"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(
                        color: Colors.red.withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () => _showActionDialog(
                      context,
                      "رفض",
                      Colors.red,
                          () {
                        context.read<LoanBloc>().add(
                          RejectLoanEvent(
                              loanId: loan.id!),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    icon:
                    const Icon(Icons.check_rounded),
                    label: const Text("قبول"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () => _showActionDialog(
                      context,
                      "قبول",
                      Colors.green,
                          () {
                        context.read<LoanBloc>().add(
                          ApproveLoanEvent(
                              loanId: loan.id!),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64.sp,
              color: theme.primaryColor.withOpacity(0.3),
            ),
            SizedBox(height: 14.h),
            Text(
              "لا توجد طلبات حالياً",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "كل شيء تحت السيطرة",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionDialog(
      BuildContext context,
      String action,
      Color color,
      VoidCallback onConfirm,
      ) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text("$action الطلب"),
        content:
        Text("هل أنت متأكد من $action هذا الطلب؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(d);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              elevation: 0,
            ),
            child: const Text(
              "تأكيد",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}