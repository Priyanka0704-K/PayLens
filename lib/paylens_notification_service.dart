import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayLensNotification {
  final String title;
  final String message;
  final String time;
  final String type;
  final bool unread;

  PayLensNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.unread,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'time': time,
      'type': type,
      'unread': unread,
    };
  }

  factory PayLensNotification.fromJson(
      Map<String, dynamic> json,
      ) {
    return PayLensNotification(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? 'general',
      unread: json['unread'] ?? true,
    );
  }
}

class PayLensNotificationService {
  static const String storageKey =
      'paylens_notifications';

  static final FlutterLocalNotificationsPlugin
  plugin =
  FlutterLocalNotificationsPlugin();

  // ============================================================
  // INITIALIZE NOTIFICATION
  // ============================================================

  static Future<void> initialize() async {
    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
    InitializationSettings(
      android: androidSettings,
    );

    // IMPORTANT:
    // Current flutter_local_notifications API
    // uses named "settings" parameter.
    await plugin.initialize(
      settings: settings,
    );

    // Android 13+ notification permission
    final androidPlugin =
    plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin
        ?.requestNotificationsPermission();
  }

  // ============================================================
  // SAVE NOTIFICATION
  // ============================================================

  static Future<void> saveNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    final prefs =
    await SharedPreferences.getInstance();

    final existing =
    await getNotifications();

    final notification =
    PayLensNotification(
      title: title,
      message: message,
      time: 'Just now',
      type: type,
      unread: true,
    );

    existing.insert(
      0,
      notification,
    );

    // Keep only latest 50 notifications
    final limited =
    existing.take(50).toList();

    await prefs.setString(
      storageKey,
      jsonEncode(
        limited
            .map(
              (notification) =>
              notification.toJson(),
        )
            .toList(),
      ),
    );

    // Show Android notification
    await _showLocalNotification(
      title: title,
      message: message,
    );
  }

  // ============================================================
  // GET NOTIFICATIONS
  // ============================================================

  static Future<List<PayLensNotification>>
  getNotifications() async {
    final prefs =
    await SharedPreferences.getInstance();

    final data =
    prefs.getString(storageKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final decoded =
      jsonDecode(data) as List<dynamic>;

      return decoded
          .map(
            (item) =>
            PayLensNotification.fromJson(
              Map<String, dynamic>.from(item),
            ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ============================================================
  // MARK ALL READ
  // ============================================================

  static Future<void> markAllRead() async {
    final notifications =
    await getNotifications();

    final updated =
    notifications.map(
          (notification) {
        return PayLensNotification(
          title: notification.title,
          message: notification.message,
          time: notification.time,
          type: notification.type,
          unread: false,
        );
      },
    ).toList();

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      storageKey,
      jsonEncode(
        updated
            .map(
              (notification) =>
              notification.toJson(),
        )
            .toList(),
      ),
    );
  }

  // ============================================================
  // SHOW LOCAL ANDROID NOTIFICATION
  // ============================================================

  static Future<void> _showLocalNotification({
    required String title,
    required String message,
  }) async {
    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(
      'paylens_alerts',
      'PayLens Alerts',
      channelDescription:
      'Subscription and payment alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    final int notificationId =
        DateTime.now()
            .millisecondsSinceEpoch;

    // IMPORTANT:
    // Current API uses named parameters.
    await plugin.show(
      id: notificationId,
      title: title,
      body: message,
      notificationDetails: details,
    );
  }
}