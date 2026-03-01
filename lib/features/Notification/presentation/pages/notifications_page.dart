import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widget/empty_notifications.dart';
import '../widget/notificationItem.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotifications());

  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("مسح جميع التنبيهات"),
          content: const Text(
            "هل أنت متأكد من رغبتك في حذف كافة التنبيهات؟ لا يمكن التراجع عن هذا الإجراء.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                context.read<NotificationBloc>().add(
                  DeleteAllNotificationsEvent(),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم مسح جميع التنبيهات')),
                );
              },
              child: const Text(
                "حذف الكل",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مركز التنبيهات',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_sweep_outlined,
              size: 24.sp,
              color: Colors.redAccent,
            ),
            onPressed: () => _showDeleteAllDialog(context),
            tooltip: "حذف الكل",
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return state.getNotificationsData.builder(
            onSuccess: (_) {
              if (state.getNotificationsData.data!.isEmpty) {
                return const EmptyNotifications().animate().fadeIn(
                  duration: 800.ms,
                );
              }

              final sortedNotifications = List.from(
                state.getNotificationsData.data!,
              )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationBloc>().add(
                    LoadNotifications(),
                  );
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  itemCount: sortedNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = sortedNotifications[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Dismissible(
                            key: Key(notification.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            onDismissed: (direction) {
                              context.read<NotificationBloc>().add(
                                DeleteNotificationEvent(notification.id.toString()),
                              );
                            },
                            child: NotificationItem(
                              notification: notification,
                              onTap: () {
                                context.read<NotificationBloc>().add(
                                  MarkNotificationAsRead(notification.id.toString()),
                                );
                              },
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                          .slideX(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    );
                  },
                ),
              );
            },
            loadingWidget: const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
            failedWidget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, color: Colors.grey, size: 50.sp),
                  SizedBox(height: 16.h),
                  Text(
                    state.getNotificationsData.errorMessage,
                    style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                  ),
                  TextButton(
                    onPressed:
                        () => context.read<NotificationBloc>().add(
                          LoadNotifications(),
                        ),
                    child: Text(
                      "إعادة المحاولة",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
