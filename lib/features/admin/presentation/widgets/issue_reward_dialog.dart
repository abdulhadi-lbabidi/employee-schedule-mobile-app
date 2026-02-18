import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_bloc.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_event.dart';

class IssueRewardDialog extends StatefulWidget {
  final String adminId;
  final String adminName;

  const IssueRewardDialog({
    super.key,
    required this.adminId,
    required this.adminName,
  });

  @override
  State<IssueRewardDialog> createState() => _IssueRewardDialogState();
}

class _IssueRewardDialogState extends State<IssueRewardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  EmployeeModel? _selectedEmployee;
  List<EmployeeModel> _employees = [];
  bool _isLoadingEmployees = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
   // final employees = await context.read<RewardAdminBloc>().fetchAllEmployees();
    if (mounted) {
      setState(() {
        // _employees = employees;
        _isLoadingEmployees = false;
      });
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
      title: Text("صرف مكافأة جديدة", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoadingEmployees)
                const CircularProgressIndicator()
              else if (_employees.isEmpty)
                const Text("لا يوجد موظفين متاحين")
              else
                DropdownButtonFormField<EmployeeModel>(
                  value: _selectedEmployee,
                  hint: const Text("اختر الموظف"),
                  items: _employees.map((employee) {
                    return DropdownMenuItem(
                      value: employee,
                      child: Text(employee.user?.fullName?? 'لا يوجد اسم'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEmployee = value;
                    });
                  },
                  validator: (value) => value == null ? "يرجى اختيار موظف" : null,
                ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "المبلغ (\$)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "يرجى إدخال المبلغ";
                  if (double.tryParse(value) == null) return "يرجى إدخال رقم صحيح";
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "السبب",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) return "يرجى إدخال السبب";
                  return null;
                },
              ),
            ],
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
              context.read<RewardAdminBloc>().add(IssueRewardEvent(
                employeeId: _selectedEmployee!.id!.toInt(),
                employeeName: _selectedEmployee!.user!.fullName!,
                // adminId: widget.adminId,
                // adminName: widget.adminName,
                amount: double.parse(_amountController.text),
                reason: _reasonController.text,
              ));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          child: const Text("تأكيد الصرف", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
