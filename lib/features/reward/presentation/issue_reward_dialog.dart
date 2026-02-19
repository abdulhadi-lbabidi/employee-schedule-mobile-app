import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_bloc.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_event.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_state.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_bloc.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_event.dart';

class IssueRewardDialog extends StatefulWidget {
  const IssueRewardDialog({super.key});

  @override
  State<IssueRewardDialog> createState() => _IssueRewardDialogState();
}

class _IssueRewardDialogState extends State<IssueRewardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  EmployeeModel? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _checkAndLoadEmployees();
  }

  void _checkAndLoadEmployees() {
    // نطلب البيانات فقط إذا لم تكن موجودة مسبقاً
    final bloc = context.read<EmployeesBloc>();
    if (!bloc.state.employeesData.isSuccess) {
      bloc.add(GetAllEmployeeEvent());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text("صرف مكافأة جديدة",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: double.maxFinite, // لضمان عرض مناسب للـ Dropdown
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // استخدام BlocBuilder لمراقبة حالة الموظفين
                BlocBuilder<EmployeesBloc, EmployeesState>(
                  builder: (context, state) {
                    if (state.employeesData.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // الوصول للبيانات بناءً على الـ Log: state.employeesData.data.data
                    final List<EmployeeModel> allEmployees =
                        state.employeesData.data?.data ?? [];

                    if (allEmployees.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Text("لا يوجد موظفين متاحين حالياً"),
                      );
                    }

                    return DropdownButtonFormField<EmployeeModel>(
                      value: _selectedEmployee,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: "اختر الموظف",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        prefixIcon: const Icon(Icons.person_search),
                      ),
                      items: allEmployees.map((employee) {
                        return DropdownMenuItem(
                          value: employee,
                          child: Text(employee.user?.fullName ?? 'بدون اسم'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEmployee = value;
                        });
                      },
                      validator: (value) => value == null ? "يرجى اختيار موظف" : null,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: "المبلغ (\$)",
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "يرجى إدخال المبلغ";
                    if (double.tryParse(value) == null) return "يرجى إدخال رقم صحيح";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "السبب",
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "يرجى إدخال السبب";
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedEmployee != null) {
              context.read<RewardAdminBloc>().add(
                IssueRewardEvent(
                  employeeId: _selectedEmployee!.id!.toInt(),
                  amount: double.parse(_amountController.text),
                  reason: _reasonController.text, adminId: 1, date: DateTime.now().toIso8601String().split('T')[0],
                ),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
          child: const Text("تأكيد الصرف", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}