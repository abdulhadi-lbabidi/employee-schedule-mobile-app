import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final AddLocalNotificationUseCase addLocalNotificationUseCase;
  final SyncNotificationsUseCase syncNotificationsUseCase;
  final SendNotificationUseCase sendNotificationUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;
  final MarkNotificationAsReadUseCase markAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.addLocalNotificationUseCase,
    required this.syncNotificationsUseCase,
    required this.sendNotificationUseCase,
    required this.deleteNotificationUseCase,
    required this.deleteAllNotificationsUseCase,
    required this.markAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<MarkNotificationAsRead>(_onMarkRead);
    on<SyncNotificationsEvent>(_onSync);
    on<AdminSendNotificationEvent>(_onSend);
    on<DeleteNotificationEvent>(_onDelete);
    on<DeleteAllNotificationsEvent>(_onDeleteAll);
    on<AddLocalNotificationEvent>(_onAddLocal);
  }

  Future<void> _onLoad(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final data = await getNotificationsUseCase();
      emit(NotificationLoaded(data));
    } catch (e) {
      emit(NotificationError('فشل جلب التنبيهات'));
    }
  }

  Future<void> _onAddLocal(
      AddLocalNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await addLocalNotificationUseCase(event.notification);
      add(LoadNotifications());
    } catch (e) {
      print('Error adding local notification: $e');
    }
  }

  Future<void> _onSync(
      SyncNotificationsEvent event, Emitter<NotificationState> emit) async {
    try {
      await syncNotificationsUseCase();
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل مزامنة التنبيهات'));
    }
  }

  Future<void> _onSend(
      AdminSendNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await sendNotificationUseCase(
        title: event.title,
        body: event.body,
        targetWorkshop: event.targetWorkshop,
        targetEmployeeId: event.targetEmployeeId,
      );
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل إرسال التنبيه للسيرفر'));
    }
  }

  Future<void> _onDelete(
      DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await deleteNotificationUseCase(event.id);
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل حذف التنبيه'));
    }
  }

  Future<void> _onDeleteAll(
      DeleteAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    try {
      await deleteAllNotificationsUseCase();
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل حذف جميع التنبيهات'));
    }
  }

  Future<void> _onMarkRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    try {
      await markAsReadUseCase(event.id);
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل وضع التنبيه كمقروء'));
    }
  }
}
