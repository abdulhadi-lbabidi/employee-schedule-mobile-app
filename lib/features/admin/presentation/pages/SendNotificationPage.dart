import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedTarget = AppStrings.allEmployees;

  final List<String> _targets = [
    AppStrings.allEmployees,
    'ورشة النجارة',
    'ورشة الخياطة',
    'المستودع',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.sendNewNotification, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(Icons.notification_add, size: 80.sp, color: Colors.blueAccent),
              ),
              SizedBox(height: 30.h),
              
              TextFormField(
                controller: _titleController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: AppStrings.notificationTitleLabel,
                  labelStyle: TextStyle(fontSize: 12.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.title, size: 20.sp),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                ),
                validator: (val) => val == null || val.isEmpty ? AppStrings.fillAllFields : null,
              ),
              SizedBox(height: 20.h),
              
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: AppStrings.notificationBodyLabel,
                  labelStyle: TextStyle(fontSize: 12.sp),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80.h),
                    child: Icon(Icons.message, size: 20.sp),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                ),
                validator: (val) => val == null || val.isEmpty ? AppStrings.fillAllFields : null,
              ),
              SizedBox(height: 20.h),
              
              DropdownButtonFormField<String>(
                value: _selectedTarget,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                decoration: InputDecoration(
                  labelText: AppStrings.targetAudience,
                  labelStyle: TextStyle(fontSize: 12.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: Icon(Icons.people_alt, size: 20.sp),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                ),
                items: _targets.map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(fontSize: 14.sp)))).toList(),
                onChanged: (val) => setState(() => _selectedTarget = val!),
              ),
              SizedBox(height: 40.h),
              
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton.icon(
                  onPressed: () => _sendNotification(context),
                  icon: Icon(Icons.send, size: 20.sp),
                  label: Text(AppStrings.send, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendNotification(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<NotificationBloc>().add(
        AdminSendNotificationEvent(
          title: _titleController.text,
          body: _bodyController.text,
          targetWorkshop: _selectedTarget == AppStrings.allEmployees ? null : _selectedTarget,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.sendSuccess, style: TextStyle(fontSize: 13.sp)), backgroundColor: Colors.green),
      );
      
      Navigator.pop(context);
    }
  }
}
