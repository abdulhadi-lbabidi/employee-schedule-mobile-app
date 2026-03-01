import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import '../../../Notification/presentation/bloc/notification_state.dart';
import '../../../Notification/presentation/widget/empty_notifications.dart';
import '../../../Notification/presentation/widget/notificationItem.dart';
import '../widgets/add_notification_sheet_widget.dart';

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

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: const Text("مسح السجل بالكامل"),
          content: const Text("هل أنت متأكد من رغبتك في حذف كافة التنبيهات المرسلة؟ لا يمكن التراجع عن هذا الإجراء."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                context.read<NotificationBloc>().add(DeleteAllNotificationsEvent());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم مسح السجل بالكامل'), backgroundColor: Colors.redAccent),
                );
              },
              child: const Text("حذف الكل", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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
          "إدارة التنبيهات",
          style: TextStyle(
            fontSize: isSmallScreen ? 18.sp : 20.sp,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
            onPressed: () => _showDeleteAllDialog(context),
            tooltip: "مسح الكل",
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.primaryColor),
            onPressed: () => context.read<NotificationBloc>().add(LoadNotifications()),
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return state.getNotificationsData.builder(
            onSuccess: (_) {
              final notifications = state.getNotificationsData.data!;
              if (notifications.isEmpty) {
                return const EmptyNotifications().animate().fadeIn();
              }

              final sortedNotifications = List.from(notifications)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NotificationBloc>().add(LoadNotifications());
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: sortedNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = sortedNotifications[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Dismissible(
                        key: Key(notification.id.toString()),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: theme.cardColor,
                                title: const Text("حذف التنبيه"),
                                content: const Text("هل تريد حذف هذا التنبيه من السجلات؟"),
                                actions: <Widget>[
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("إلغاء")),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("حذف", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (_) {
                          context.read<NotificationBloc>().add(DeleteNotificationEvent(notification.id.toString()));
                        },
                        background: Container(
                          decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15.r)),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        ),
                        child: NotificationItem(notification: notification, onTap: () {}),
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.05, end: 0);
                  },
                ),
              );
            },
            loadingWidget: const Center(child: CircularProgressIndicator()),
            failedWidget: Center(child: Text("فشل تحميل البيانات", style: TextStyle(color: theme.disabledColor))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        onPressed: () => _showSendNotificationSheet(context, theme),
        icon: const Icon(Icons.send_rounded, color: Colors.white),
        label: Text(isSmallScreen ? "إرسال" : "إرسال تنبيه جديد", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().scale(delay: 500.ms),
    );
  }

  void _showSendNotificationSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
      builder: (_) => AddNotificationSheetWidget(theme: theme),
    );
  }
}
