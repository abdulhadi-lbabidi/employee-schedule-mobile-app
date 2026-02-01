import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import '../../../Notification/presentation/bloc/notification_state.dart';
import '../../../Notification/presentation/widget/empty_notifications.dart';
import '../../../Notification/presentation/widget/notificationItem.dart';


class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "إدارة التنبيهات المرسلة",
          style: TextStyle(fontSize: isSmallScreen ? 18.sp : 20.sp, fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.primaryColor),
            onPressed: () => context.read<NotificationBloc>().add(LoadNotifications()),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const EmptyNotifications().animate().fadeIn();
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: 16.h,
              ),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Dismissible(
                    key: Key(notification.id),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: theme.cardColor,
                            title: Text("تأكيد الحذف", style: TextStyle(color: colorScheme.error)),
                            content: Text("هل أنت متأكد من رغبتك في حذف هذا الإشعار نهائياً؟", 
                              style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("إلغاء"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("حذف", style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (_) {
                      context.read<NotificationBloc>().add(DeleteNotificationEvent(notification.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حذف التنبيه من السجلات'), duration: Duration(seconds: 1)),
                      );
                    },
                    background: Container(
                      decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15.r)),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                    ),
                    child: NotificationItem(notification: notification, onTap: () {  },),
                  ),
                ).animate()
                 .fadeIn(delay: (200 + (index * 150)).ms, duration: 600.ms) // أبطأ وسلس
                 .slideX(begin: 0.05, end: 0);
              },
            );
          }

          return Center(child: Text("حدث خطأ في تحميل السجلات", style: TextStyle(color: theme.disabledColor)));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () => _showSendNotificationSheet(context, theme),
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        label: Text(
          isSmallScreen ? "إرسال" : "إرسال تنبيه جديد",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ).animate().scale(delay: 800.ms, duration: 800.ms, curve: Curves.elasticOut),
    );
  }

  void _showSendNotificationSheet(BuildContext context, ThemeData theme) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          left: 24.w,
          right: 24.w,
          top: 24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(10.r)))),
            SizedBox(height: 20.h),
            Text("بث تنبيه جديد للموظفين", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor)),
            SizedBox(height: 20.h),
            TextField(
              controller: titleController, 
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: const InputDecoration(labelText: "عنوان التنبيه", prefixIcon: Icon(Icons.title_rounded))
            ),
            SizedBox(height: 15.h),
            TextField(
              controller: bodyController, 
              maxLines: 3, 
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: const InputDecoration(labelText: "نص الرسالة", prefixIcon: Icon(Icons.message_rounded))
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                onPressed: () {
                  if (titleController.text.isNotEmpty && bodyController.text.isNotEmpty) {
                    context.read<NotificationBloc>().add(AdminSendNotificationEvent(
                      title: titleController.text,
                      body: bodyController.text,
                    ));
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال التنبيه بنجاح ✓"), backgroundColor: Colors.green));
                  }
                },
                child: Text("إرسال الآن", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
