import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/features/Notification/domain/usecases/check_in_use_case.dart';
import 'package:untitled8/features/Notification/domain/usecases/check_out_use_case.dart';
import '../../../../core/di/injection.dart';
import '../../data/datasources/notification_locale_data_sources.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/send_notification_use_case.dart';
import 'notification_event.dart' hide NotificationError;
import 'notification_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  // final AddLocalNotificationUseCase addLocalNotificationUseCase;
  // final SyncNotificationsUseCase syncNotificationsUseCase;
  final SendNotificationUseCase sendNotificationUseCase;
  final CheckInUseCase checkInUseCase;
  final CheckOutUseCase checkOutUseCase;

  final DeleteNotificationUseCase deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;
  // final MarkNotificationAsReadUseCase markAsReadUseCase;

  NotificationBloc(
    this.getNotificationsUseCase,
    //  this.addLocalNotificationUseCase,
    // // required this.syncNotificationsUseCase,
     this.deleteNotificationUseCase,
     this.deleteAllNotificationsUseCase,
    //  this.markAsReadUseCase,
    this.sendNotificationUseCase,
    this.checkInUseCase,
    this.checkOutUseCase,
  ) : super(NotificationState()) {
    on<LoadNotifications>(_onLoad);

    on<DeleteNotificationEvent>(_onDelete);
    on<DeleteAllNotificationsEvent>(_onDeleteAll);
    on<AddLocalNotificationEvent>(_onAddLocal);
    on<SendNotificationsEvent>(_onSend);
    on<CheckInEvent>(_checkIn);
    on<CheckOutEvent>(_checkOut);
  }

  Future<void> _onSend(
    SendNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        sendNotificationData: state.sendNotificationData.setLoading(),
      ),
    );

    final result = await sendNotificationUseCase(event.params);
    result.fold(
      (l) => emit(
        state.copyWith(
          sendNotificationData: state.sendNotificationData.setFaild(
            errorMessage: l.message,
          ),
        ),
      ),
      (r) => emit(
        state.copyWith(
          sendNotificationData: state.sendNotificationData.setSuccess(),
        ),
      ),
    );
  }

  Future<void> _checkIn(
    CheckInEvent event,
    Emitter<NotificationState> emit,
  ) async
  {
    emit(state.copyWith(checkInData: state.checkInData.setLoading()));

    final result = await checkInUseCase(event.params);
    result.fold(
      (l) => emit(
        state.copyWith(
          checkInData: state.checkInData.setFaild(errorMessage: l.message),
        ),
      ),
      (r) {
        emit(state.copyWith(checkInData: state.checkInData.setSuccess()));
      },
    );
  }

  Future<void> _checkOut(
    CheckOutEvent event,
    Emitter<NotificationState> emit,
  ) async
  {
    emit(state.copyWith(checkOutData: state.checkOutData.setLoading()));

    final result = await checkOutUseCase(event.params);
    result.fold(
      (l) => emit(
        state.copyWith(
          checkOutData: state.checkOutData.setFaild(errorMessage: l.message),
        ),
      ),
      (r) =>
          emit(state.copyWith(checkOutData: state.checkOutData.setSuccess())),
    );
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async
  {
    emit(
      state.copyWith(
        getNotificationsData: state.getNotificationsData.setLoading(),
      ),
    );

    final result = await getNotificationsUseCase();

    result.fold(
      (l) => emit(
        state.copyWith(
          getNotificationsData: state.getNotificationsData.setFaild(
            errorMessage: l.message,
          ),
        ),
      ),
      (r) {
        sl<NotificationLocaleDataSources>().setLocaleNotifications(r.data??[]);
        emit(
          state.copyWith(
            getNotificationsData: state.getNotificationsData.setSuccess(
              data: r.data,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddLocal(
    AddLocalNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async
  {
    try {
      // await addLocalNotificationUseCase(event.notification);
      add(LoadNotifications());
    } catch (e) {
      print('Error adding local notification: $e');
    }
  }



  Future<void> _onDelete(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await deleteNotificationUseCase(event.id);
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل حذف التنبيه'));
    }
  }

  Future<void> _onDeleteAll(
    DeleteAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await deleteAllNotificationsUseCase();
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('فشل حذف جميع التنبيهات'));
    }
  }


}
