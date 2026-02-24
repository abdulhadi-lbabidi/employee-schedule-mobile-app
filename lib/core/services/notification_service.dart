
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../common/helper/src/app_varibles.dart';

/// =====================================================
/// ================= DEBUG PRINTER =====================
/// =====================================================

void debugPrintRemoteMessage(RemoteMessage message, {required String from}) {
  print("\n════════════════════════════════════════════");
  print("📦 MESSAGE DEBUG FROM: $from");
  print("🆔 Message ID: ${message.messageId}");
  print("📤 From: ${message.from}");
  print("📅 Sent Time: ${message.sentTime}");
  print("⌛ TTL: ${message.ttl}");
  print("📂 Category: ${message.category}");
  print("📦 CollapseKey: ${message.collapseKey}");

  print("------------ NOTIFICATION ------------");
  print("🔹 Title: ${message.notification?.title}");
  print("🔹 Body: ${message.notification?.body}");
  print("🔹 Android: ${message.notification?.android}");
  print("🔹 Apple: ${message.notification?.apple}");

  print("------------ DATA ------------");
  if (message.data.isEmpty) {
    print("⚠️ No data payload");
  } else {
    message.data.forEach((key, value) {
      print("🔑 $key : $value");
    });
  }

  print("════════════════════════════════════════════\n");
}

/// =====================================================
/// =============== BACKGROUND HANDLER ==================
/// =====================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrintRemoteMessage(message, from: "TERMINATED BACKGROUND HANDLER");
}

/// =====================================================
/// =============== AWESOME ACTION LISTENER =============
/// =====================================================

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction action) async {
  print("\n════════════════════════════════════════════");
  print("🔔 AWESOME NOTIFICATION CLICKED");
  print("🆔 ID: ${action.id}");
  print("📦 ChannelKey: ${action.channelKey}");
  print("📌 Title: ${action.title}");
  print("📝 Body: ${action.body}");
  print("📂 Payload: ${action.payload}");
  print("════════════════════════════════════════════\n");

  if (action.payload != null && action.payload!.isNotEmpty) {
    print('➡️ nav from sector 1');
  }
}

/// =====================================================
/// ================= Notification Utils =================
/// =====================================================

class NotificationUtils {
  NotificationUtils._();
  static final NotificationUtils _instance = NotificationUtils._();
  factory NotificationUtils() => _instance;

  static final AwesomeNotifications _awesome = AwesomeNotifications();

  static int _unreadCount = 0;

  /// ---------------- INIT ALL ----------------
  Future<void> initAllNotifications() async {
    await _initFirebase();
    await _initAwesomeNotifications();
    await _ensurePermission();
    _registerListeners();
    await _checkTerminatedNotification();
    _startAwesomeListeners();
  }

  /// ---------------- FIREBASE INIT ----------------
  Future<void> _initFirebase() async {
    await Firebase.initializeApp();

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      AppVariables.fcmToken = token;
      print("✅ FCM Token: $token");
    }
  }

  /// ---------------- AWESOME INIT ----------------
  Future<void> _initAwesomeNotifications() async {
    await _awesome.initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Basic Instant Notification',
          importance: NotificationImportance.High,
          defaultColor: const Color(0xffBF956B),
          onlyAlertOnce: true,
          channelShowBadge: true,
        ),
      ],
    );
  }

  /// ---------------- PERMISSION ----------------
  Future<void> _ensurePermission() async {
    final allowed = await _awesome.isNotificationAllowed();
    if (!allowed) {
      await _awesome.requestPermissionToSendNotifications();
    }
  }

  /// ---------------- LISTENERS ----------------
  void _startAwesomeListeners() {
    _awesome.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  void _registerListeners() {
    /// Foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    /// Background (when tapped)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);

    /// Terminated (background isolate)
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  /// ---------------- FOREGROUND ----------------
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrintRemoteMessage(message, from: "FOREGROUND");

    final payload = message.data.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
    );

    _unreadCount++;

    await _awesome.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ??
            message.data['title'] ??
            '',
        body: message.notification?.body ??
            message.data['body'] ??
            '',
        payload: payload,
        badge: _unreadCount,
      ),
    );
  }

  /// ---------------- BACKGROUND TAP ----------------
  void _handleBackgroundTap(RemoteMessage message) {
    debugPrintRemoteMessage(message, from: "BACKGROUND TAP");
    print("➡️ nav from sector 2");
  }

  /// ---------------- TERMINATED CHECK ----------------
  Future<void> _checkTerminatedNotification() async {
    final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrintRemoteMessage(initialMessage, from: "TERMINATED TAP");
    }
  }
}
