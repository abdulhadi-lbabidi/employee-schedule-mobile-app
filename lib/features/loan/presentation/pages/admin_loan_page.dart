import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 🔹 إضافة مكتبة الانميشن
import 'package:intl/intl.dart';
import '../../../../core/utils/date_helper.dart';
import '../../domain/entities/loan_entity.dart';
import '../bloc/loan_bloc.dart';
import '../../../admin/domain/entities/employee_entity.dart';
import '../../../admin/presentation/bloc/employees/employees_bloc.dart';
import '../../../admin/presentation/bloc/employees/employees_event.dart';
import '../../../admin/presentation/bloc/employees/employees_state.dart';

class AdminLoanPage extends StatefulWidget {
  const AdminLoanPage({super.key});

  @override
  State<AdminLoanPage> createState() => _AdminLoanPageState();
}

class _AdminLoanPageState extends State<AdminLoanPage> {
  String searchQuery = "";
  LoanStatus? statusFilter;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<LoanBloc>().add(LoadAllLoans());
    context.read<EmployeesBloc>().add(LoadEmployeesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: isSearchVisible 
          ? _buildSearchField(theme)
          : Text("إدارة السلف", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        actions: [
          IconButton(
            icon: Icon(isSearchVisible ? Icons.close : Icons.search, color: theme.primaryColor),
            onPressed: () => setState(() {
              isSearchVisible = !isSearchVisible;
              if (!isSearchVisible) searchQuery = "";
            }),
          ),
          _buildFilterMenu(theme),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLoanSheet(context, theme),
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text("سلفة جديدة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,
      ).animate().scale(delay: 1000.ms, duration: 800.ms, curve: Curves.bounceOut),
      body: Column(
        children: [
          _buildDateSelector(theme).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
          _buildFilterChips(theme).animate().fadeIn(delay: 200.ms),
          Expanded(
            child: BlocBuilder<LoanBloc, LoanState>(
              builder: (context, state) {
                if (state is LoanLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LoansLoaded) {
                  final filteredLoans = _applyFilters(state.loans);
                  
                  if (filteredLoans.isEmpty) {
                    return _buildEmptyState(theme).animate().fadeIn();
                  }
                  
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredLoans.length,
                    itemBuilder: (context, index) => 
                      _buildLoanCard(context, filteredLoans[index], theme)
                        .animate()
                        .fadeIn(delay: (400 + (index * 150)).ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0),
                  );
                } else if (state is LoanError) {
                  return Center(child: Text(state.message, style: TextStyle(color: colorScheme.error)));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      autofocus: true,
      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: "ابحث عن موظف...",
        hintStyle: theme.textTheme.bodySmall,
        border: InputBorder.none,
      ),
      onChanged: (val) => setState(() => searchQuery = val),
    );
  }

  Widget _buildFilterMenu(ThemeData theme) {
    return PopupMenuButton<LoanStatus?>(
      icon: Icon(Icons.filter_list_alt, color: theme.primaryColor),
      color: theme.cardColor,
      onSelected: (status) => setState(() => statusFilter = status),
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text("الكل")),
        const PopupMenuItem(value: LoanStatus.unpaid, child: Text("غير مسددة")),
        const PopupMenuItem(value: LoanStatus.partiallyPaid, child: Text("جزئياً")),
        const PopupMenuItem(value: LoanStatus.fullyPaid, child: Text("بالكامل")),
      ],
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: theme.cardColor.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: _smallDropdown<int>(
              theme: theme,
              value: selectedYear,
              items: DateHelper.getYearsRange(),
              onChanged: (v) => setState(() => selectedYear = v!),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _smallDropdown<int>(
              theme: theme,
              value: selectedMonth,
              items: List.generate(12, (i) => i + 1),
              itemLabel: (m) => DateHelper.getMonthName(m),
              onChanged: (v) => setState(() => selectedMonth = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallDropdown<T>({required ThemeData theme, required T value, required List<T> items, required ValueChanged<T?> onChanged, String Function(T)? itemLabel}) {
    return Container(
      height: 35.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: theme.cardColor,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(itemLabel != null ? itemLabel(i) : i.toString(), style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _filterChip(theme, "الكل", null),
          _filterChip(theme, "غير مسددة", LoanStatus.unpaid),
          _filterChip(theme, "جزئياً", LoanStatus.partiallyPaid),
          _filterChip(theme, "بالكامل", LoanStatus.fullyPaid),
        ],
      ),
    );
  }

  Widget _filterChip(ThemeData theme, String label, LoanStatus? status) {
    final isSelected = statusFilter == status;
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: FilterChip(
        label: Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp, color: isSelected ? theme.colorScheme.onPrimary : null, fontWeight: FontWeight.bold)),
        selected: isSelected,
        onSelected: (val) => setState(() => statusFilter = status),
        selectedColor: theme.colorScheme.primary,
        checkmarkColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  List<LoanEntity> _applyFilters(List<LoanEntity> loans) {
    return loans.where((loan) {
      final matchesSearch = loan.employeeName.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = statusFilter == null || loan.status == statusFilter;
      final matchesMonth = loan.date.month == selectedMonth && loan.date.year == selectedYear;
      return matchesSearch && matchesStatus && matchesMonth;
    }).toList();
  }

  Widget _buildLoanCard(BuildContext context, LoanEntity loan, ThemeData theme) {
    final statusColor = _getStatusColor(loan.status);

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12.h),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r), side: BorderSide(color: theme.dividerColor.withOpacity(0.1))),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(Icons.person_rounded, color: theme.colorScheme.primary, size: 24.sp),
        ),
        title: Text(loan.employeeName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        subtitle: Text("${NumberFormat.decimalPattern().format(loan.amount)} ل.س", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13.sp)),
        trailing: _statusBadge(loan.status, statusColor, theme),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _infoRow(theme, Icons.money, "المبلغ الإجمالي:", "${NumberFormat.decimalPattern().format(loan.amount)} ل.س"),
                _infoRow(theme, Icons.check_circle_outline, "المسدد:", "${NumberFormat.decimalPattern().format(loan.paidAmount)} ل.س", color: Colors.green),
                _infoRow(theme, Icons.pending_outlined, "المتبقي:", "${NumberFormat.decimalPattern().format(loan.remainingAmount)} ل.س", color: theme.colorScheme.error),
                _infoRow(theme, Icons.info_outline, "السبب:", loan.reason),
                _infoRow(theme, Icons.calendar_month, "تاريخ الطلب:", DateFormat('yyyy-MM-dd').format(loan.date)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (loan.status != LoanStatus.fullyPaid)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0),
                            onPressed: () => _showRecordPaymentDialog(context, loan, theme),
                            child: const Text("تسجيل دفع"),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: OutlinedButton(
                          onPressed: () => _showUpdateStatusDialog(context, loan, theme),
                          child: const Text("تعديل الحالة"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statusBadge(LoanStatus status, Color color, ThemeData theme) {
    String text = status == LoanStatus.unpaid ? "غير مسدد" : (status == LoanStatus.partiallyPaid ? "جزئي" : "كامل");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(text, style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoRow(ThemeData theme, IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: theme.iconTheme.color?.withOpacity(0.5)),
          SizedBox(width: 10.w),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Color _getStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.unpaid: return Colors.red;
      case LoanStatus.partiallyPaid: return Colors.orange;
      case LoanStatus.fullyPaid: return Colors.green;
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 70.sp, color: theme.dividerColor.withOpacity(0.2)),
          SizedBox(height: 16.h),
          Text("لا توجد سجلات حالياً", style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddLoanSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      builder: (context) => _AddLoanSheet(theme: theme),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, LoanEntity loan, ThemeData theme) {
    showDialog(
      context: context,
      builder: (d) => SimpleDialog(
        backgroundColor: theme.cardColor,
        title: const Text("تحديث حالة السلفة"),
        children: LoanStatus.values.map((s) => SimpleDialogOption(
          onPressed: () { context.read<LoanBloc>().add(UpdateLoanStatus(loan.id, s)); Navigator.pop(d); },
          child: Text(s == LoanStatus.unpaid ? "غير مسددة" : (s == LoanStatus.partiallyPaid ? "جزئية" : "كاملة")),
        )).toList(),
      ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context, LoanEntity loan, ThemeData theme) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: const Text("تسجيل دفع تسديد"),
        content: TextField(
          controller: c, 
          keyboardType: TextInputType.number, 
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: "المبلغ", 
            suffixText: "ل.س", 
            hintText: "المتبقي: ${NumberFormat.decimalPattern().format(loan.remainingAmount)}",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text("إلغاء")),
          ElevatedButton(onPressed: () {
            if (c.text.isNotEmpty) {
              context.read<LoanBloc>().add(RecordPayment(loan.id, double.parse(c.text)));
              Navigator.pop(d);
            }
          }, child: const Text("تسجيل الدفعة")),
        ],
      ),
    );
  }
}

class _AddLoanSheet extends StatefulWidget {
  final ThemeData theme;
  const _AddLoanSheet({required this.theme});

  @override
  State<_AddLoanSheet> createState() => _AddLoanSheetState();
}

class _AddLoanSheetState extends State<_AddLoanSheet> {
  EmployeeEntity? selectedEmployee;
  final amountController = TextEditingController();
  final reasonController = TextEditingController();
  String empSearch = "";

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20.w, right: 20.w, top: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(10.r)))),
          SizedBox(height: 20.h),
          Text("إضافة سلفة جديدة", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
          SizedBox(height: 15.h),
          
          Text("اختر الموظف", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: _showEmployeePicker,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12.r),
                color: theme.scaffoldBackgroundColor,
              ),
              child: Row(
                children: [
                  Icon(Icons.person_search_outlined, color: theme.colorScheme.primary, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(selectedEmployee?.name ?? "اضغط للاختيار من القائمة", 
                    style: theme.textTheme.bodyMedium?.copyWith(color: selectedEmployee == null ? theme.disabledColor : null, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: "قيمة السلفة", suffixText: "ل.س"),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(labelText: "سبب السلفة (اختياري)"),
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
              onPressed: _submit,
              child: Text("حفظ السلفة", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  void _showEmployeePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => Container(
          height: 500.h,
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: "ابحث عن اسم الموظف...", prefixIcon: const Icon(Icons.search)),
                onChanged: (val) => setLocalState(() => empSearch = val),
              ),
              Expanded(
                child: BlocBuilder<EmployeesBloc, EmployeesState>(
                  builder: (context, state) {
                    if (state is EmployeesLoaded) {
                      final list = state.employees.where((e) => e.name.toLowerCase().contains(empSearch.toLowerCase())).toList();
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final e = list[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: widget.theme.colorScheme.primary.withOpacity(0.1),
                              child: Text(e.name[0], style: TextStyle(color: widget.theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                            ),
                            title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(e.workshopName, style: TextStyle(color: widget.theme.disabledColor, fontSize: 12.sp)),
                            onTap: () {
                              setState(() => selectedEmployee = e);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (selectedEmployee != null && amountController.text.isNotEmpty) {
      final loan = LoanEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: selectedEmployee!.id,
        employeeName: selectedEmployee!.name,
        amount: double.parse(amountController.text),
        paidAmount: 0,
        reason: reasonController.text,
        date: DateTime.now(),
        status: LoanStatus.unpaid,
      );
      context.read<LoanBloc>().add(AddLoan(loan));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت إضافة السلفة بنجاح"), backgroundColor: Colors.green));
    }
  }
}
