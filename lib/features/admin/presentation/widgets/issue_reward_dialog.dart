import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_bloc.dart';
import 'package:untitled8/features/reward/presentation/bloc/reward_admin/reward_admin_event.dart';

class IssueRewardDialog extends StatefulWidget {
  final int employeeId;
  final String employeeName;

  const IssueRewardDialog({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<IssueRewardDialog> createState() => _IssueRewardDialogState();
}

class _IssueRewardDialogState extends State<IssueRewardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("منح مكافأة لـ ${widget.employeeName}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "المبلغ (ل.س)",
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
            if (_formKey.currentState!.validate()) {
              context.read<RewardAdminBloc>().add(IssueRewardEvent(
                employeeId: widget.employeeId,
                employeeName: widget.employeeName,
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
