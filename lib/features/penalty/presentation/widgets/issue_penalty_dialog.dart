import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/core/data_state_model.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_bloc.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_event.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_state.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_bloc.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_state.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_all_workshop_response.dart';
import '../../../admin/data/models/workshop_models/workshop_model.g.dart';
import '../../../admin/presentation/bloc/workshops/workshops_event.dart';
import '../bloc/penalty_bloc.dart';

class IssuePenaltyDialog extends StatefulWidget {
  const IssuePenaltyDialog({super.key});

  @override
  State<IssuePenaltyDialog> createState() => _IssuePenaltyDialogState();
}

class _IssuePenaltyDialogState extends State<IssuePenaltyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  EmployeeModel? _selectedEmployee;
  WorkshopModel? _selectedWorkshop;

  @override
  void initState() {
    super.initState();
    context.read<EmployeesBloc>().add(GetAllEmployeeEvent());
    context.read<WorkshopsBloc>().add(GetAllWorkShopEvent());
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
      title: Text("إصدار عقوبة مالية", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.red)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  return state.employeesData.builder(
                    onSuccess: (data) {
                      final list = data?.data ?? [];
                      return DropdownButtonFormField<EmployeeModel>(
                        value: _selectedEmployee,
                        hint: const Text("اختر الموظف"),
                        items: list.map((e) => DropdownMenuItem(value: e, child: Text(e.user?.fullName ?? 'No Name'))).toList(),
                        onChanged: (val) => setState(() => _selectedEmployee = val),
                        validator: (val) => val == null ? "يرجى اختيار موظف" : null,
                      );
                    },
                    loadingWidget: const CircularProgressIndicator(),
                    failedWidget: const Text("فشل تحميل الموظفين"),
                  );
                },
              ),
              SizedBox(height: 12.h),
              BlocBuilder<WorkshopsBloc, WorkshopsState>(
                builder: (context, state) {
                  return state.getAllWorkshopData.builder(
                    onSuccess: (data) {
                      final list = data?.data ?? [];
                      return DropdownButtonFormField<WorkshopModel>(
                        value: _selectedWorkshop,
                        hint: const Text("اختر الورشة"),
                        items: list.map((w) => DropdownMenuItem(value: w, child: Text(w.name ?? ''))).toList(),
                        onChanged: (val) => setState(() => _selectedWorkshop = val),
                        validator: (val) => val == null ? "يرجى اختيار الورشة" : null,
                      );
                    },
                    loadingWidget: const CircularProgressIndicator(),
                    failedWidget: const Text("فشل تحميل الورشات"),
                  );
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "قيمة خصم (\$)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "أدخل المبلغ" : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: "سبب الخصم", border: OutlineInputBorder()),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? "أدخل السبب" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
        BlocConsumer<PenaltyBloc, PenaltyState>(
          listener: (context, state) {
            state.issuePenaltyStatus.listenerFunction(
              onSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تسجيل العقوبة بنجاح"), backgroundColor: Colors.green));
                Navigator.pop(context);
              },
            );
          },
          builder: (context, state) {
            // 🔹 تعديل هنا: لا يظهر اللودينج إلا عند الحالة loading فعلياً
            if (state.issuePenaltyStatus.status == BlocStatus.loading) return const CircularProgressIndicator();
            return ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("تأكيد العقوبة", style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedEmployee != null && _selectedWorkshop != null) {
      context.read<PenaltyBloc>().add(
        IssuePenaltyEvent(
          employeeId: _selectedEmployee!.id!,
          workshopId: _selectedWorkshop!.id!,
          amount: double.parse(_amountController.text),
          reason: _reasonController.text,
          adminId: 1,
          date: DateTime.now(),
        ),
      );
    }
  }
}
