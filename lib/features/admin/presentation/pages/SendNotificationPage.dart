import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import '../bloc/workshops/workshops_bloc.dart';
import '../bloc/workshops/workshops_state.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  // نستخدم الـ ID بدلاً من الاسم
  String? _selectedWorkshopId;

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
                decoration: InputDecoration(
                  labelText: AppStrings.notificationTitleLabel,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (val) => val == null || val.isEmpty ? AppStrings.fillAllFields : null,
              ),
              SizedBox(height: 20.h),
              
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: AppStrings.notificationBodyLabel,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  prefixIcon: const Icon(Icons.message),
                ),
                validator: (val) => val == null || val.isEmpty ? AppStrings.fillAllFields : null,
              ),
              SizedBox(height: 20.h),
              
              // اختيار الورشة من البيانات الحقيقية
              BlocBuilder<WorkshopsBloc, WorkshopsState>(
                builder: (context, state) {
                  final workshops = state.getAllWorkShopData.data ?? [];
                  return DropdownButtonFormField<String>(
                    value: _selectedWorkshopId,
                    decoration: InputDecoration(
                      labelText: "الجمهور المستهدف",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                      prefixIcon: const Icon(Icons.people_alt),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text("جميع الموظفين")),
                      ...workshops.map((w) => DropdownMenuItem(
                        value: w.id.toString(),
                        child: Text(w.name),
                      )),
                    ],
                    onChanged: (val) => setState(() => _selectedWorkshopId = val),
                  );
                },
              ),
              SizedBox(height: 40.h),
              
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton.icon(
                  onPressed: () => _sendNotification(context),
                  icon: const Icon(Icons.send),
                  label: Text("إرسال التنبيه الآن", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
          targetWorkshop: _selectedWorkshopId, // نرسل الـ ID الحقيقي
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("جاري الإرسال..."), backgroundColor: Colors.blue),
      );
      
      Navigator.pop(context);
    }
  }
}
