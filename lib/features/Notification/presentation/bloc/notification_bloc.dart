import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<MarkNotificationAsRead>(_onMarkRead);
    on<SyncNotificationsEvent>(_onSync);
    on<AdminSendNotificationEvent>(_onSend);
    on<DeleteNotificationEvent>(_onDelete);
    on<DeleteAllNotificationsEvent>(_onDeleteAll);
    on<AddLocalNotificationEvent>(_onAddLocal);
  }

  Future<void> _onLoad(LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final data = await repository.getNotifications();
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError('فشل جلب التنبيهات'));
    }
  }

  Future<void> _onAddLocal(AddLocalNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.addLocalNotification(event.notification);
      add(LoadNotifications());
    } catch (e) {
      print('Error adding local notification: $e');
    }
  }

  Future<void> _onSync(SyncNotificationsEvent event, Emitter<NotificationState> emit) async {
    await repository.syncNotifications();
    add(LoadNotifications());
  }

  Future<void> _onSend(AdminSendNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.sendNotification(
        title: event.title,
        body: event.body,
        targetWorkshop: event.targetWorkshop,
      );
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل إرسال التنبيه للسيرفر'));
    }
  }

  Future<void> _onDelete(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.deleteNotification(event.id);
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل حذف التنبيه'));
    }
  }

  Future<void> _onDeleteAll(DeleteAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    try {
      await repository.deleteAllNotifications();
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل حذف جميع التنبيهات'));
    }
  }

  Future<void> _onMarkRead(MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    await repository.markAsRead(event.id);
    add(LoadNotifications());
  }
}
