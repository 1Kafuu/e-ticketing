import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

  static Future<void> init() async {
    await _awesomeNotifications.initialize(
      null, // icon default
      [
        NotificationChannel(
          channelKey: 'ticket_updates',
          channelName: 'Ticket Updates',
          channelDescription: 'Notifikasi perubahan status tiket',
          defaultColor: const Color(0xFF9D50BB),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
      debug: true,
    );
  }

  static Future<void> requestPermission() async {
    bool isAllowed = await _awesomeNotifications.isNotificationAllowed();
    if (!isAllowed) {
      await _awesomeNotifications.requestPermissionToSendNotifications();
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _awesomeNotifications.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'ticket_updates',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}