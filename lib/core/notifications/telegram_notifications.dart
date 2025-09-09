import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TelegramNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);
  }

  static Future<void> showMessageNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const android = AndroidNotificationDetails(
      'messages_channel',
      'Сообщения',
      channelDescription: 'Уведомления о новых сообщениях',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: json.encode(payload),
    );
  }
}