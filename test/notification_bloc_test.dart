import 'package:flutter_test/flutter_test.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_bloc.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_event.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_state.dart';
import 'package:untitled8/features/Notification/domain/repositories/notification_repository.dart';
import 'package:untitled8/features/Notification/domain/entities/notification_entity.dart';
import 'package:untitled8/features/Notification/data/model/notification_model.dart';

// محاكاة مستودع الإشعارات
class MockNotificationRepository implements NotificationRepository {
  List<NotificationModel> mockData = [];

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    return mockData.map((m) => NotificationEntity(
      id: m.id,
      title: m.title,
      body: m.body,
      type: m.type,
      isRead: m.isRead,
      createdAt: m.createdAt,
    )).toList();
  }

  @override
  Future<void> addLocalNotification(NotificationModel notification) async {
    mockData.add(notification);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = mockData.indexWhere((n) => n.id == id);
    if (index != -1) mockData[index].isRead = true;
  }

  @override
  Future<void> deleteNotification(String id) async {
    mockData.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> deleteAllNotifications() async {
    mockData.clear();
  }

  @override
  Future<void> syncNotifications() async {}

  @override
  Future<void> sendNotification({required String title, required String body, String? targetWorkshop, String? targetEmployeeId}) async {}
}

void main() {
  late NotificationBloc notificationBloc;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    notificationBloc = NotificationBloc(mockRepository);
  });

  tearDown(() {
    notificationBloc.close();
  });

  group('NotificationBloc Unit Tests', () {
    test('يجب أن يبدأ بـ NotificationInitial', () {
      expect(notificationBloc.state, isA<NotificationInitial>());
    });

    test('يجب أن يصدر [Loading, Loaded] عند طلب تحميل الإشعارات', () async {
      final expectedStates = [
        isA<NotificationLoading>(),
        isA<NotificationLoaded>(),
      ];

      expectLater(notificationBloc.stream, emitsInOrder(expectedStates));
      notificationBloc.add(LoadNotifications());
    });

    test('يجب إضافة إشعار جديد بنجاح عند استدعاء AddLocalNotificationEvent', () async {
      final newNotif = NotificationModel(
        id: "1",
        title: "اختبار",
        body: "محتوى",
        createdAt: DateTime.now(),
        type: "test",
        isRead: false,
      );

      // إضافة الإشعار
      notificationBloc.add(AddLocalNotificationEvent(newNotif));
      
      // ننتظر قليلاً لمعالجة الحدث ثم نطلب التحميل للتأكد
      await Future.delayed(Duration.zero);
      notificationBloc.add(LoadNotifications());

      expectLater(notificationBloc.stream, emitsThrough(predicate((state) {
        if (state is NotificationLoaded) {
          return state.notifications.any((n) => n.id == "1");
        }
        return false;
      })));
    });

    test('يجب مسح جميع الإشعارات عند استدعاء DeleteAllNotificationsEvent', () async {
      // إضافة إشعار أولاً
      mockRepository.mockData.add(NotificationModel(
        id: "1", title: "T", body: "B", createdAt: DateTime.now(), type: "T", isRead: false
      ));

      notificationBloc.add(DeleteAllNotificationsEvent());
      
      await Future.delayed(Duration.zero);
      notificationBloc.add(LoadNotifications());

      expectLater(notificationBloc.stream, emitsThrough(predicate((state) {
        if (state is NotificationLoaded) {
          return state.notifications.isEmpty;
        }
        return false;
      })));
    });
  });
}
