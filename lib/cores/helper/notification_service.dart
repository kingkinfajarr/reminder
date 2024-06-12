//notif_helper.dart
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../features/reminder/domain/entity/reminder_entity.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FlutterLocalNotificationService {
  static bool _isWeb = false;
  static bool isFlutterLocalNotificationsInitialized = false;
  static AndroidNotificationChannel? channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> init({bool isWeb = false}) async {
    _isWeb = isWeb;
    tz.initializeTimeZones();
    if (isWeb) {
      // var permission = web.Notification.permission;
      // if (permission != 'granted') {
      //   permission = await web.Notification.requestPermission();
      // }
      return;
    }

    bool? isPermissionGranted = false;
    if (Platform.isAndroid) {
      isPermissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
    if (Platform.isIOS) {
      isPermissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (isPermissionGranted == true) {
      var initializationSettingsAndroid = const AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Fix icon path
      var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {},
      );
      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {},
        onDidReceiveBackgroundNotificationResponse: _backgroundHandler,
      );
    }
  }

  static Future<void> setupFlutterNotifications() => init();

  static void _backgroundHandler(NotificationResponse details) {}

  static void scheduleNotification(ReminderEntity reminder) {
    if (reminder.id != null) {
      flutterLocalNotificationsPlugin.cancel(reminder.id!);
    }
    if (reminder.hour != null && reminder.minute != null) {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel?.id ?? '',
        channel?.name ?? '',
        channelDescription: channel?.description,
        icon: '@mipmap/ic_launcher',
        styleInformation: const BigTextStyleInformation(''),
      );
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
      );
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      tz.initializeTimeZones();

      final startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        reminder.hour,
        reminder.minute,
      );
      final currentTime = DateTime.now();

      final diffHr = currentTime.difference(startTime).inHours;
      final diffMn = currentTime.difference(startTime).inMinutes;
      final diffSc = currentTime.difference(startTime).inSeconds;

      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.id ?? 0,
        reminder.title,
        reminder.description,
        tz.TZDateTime.now(tz.local).add(
          Duration(
            minutes: -diffMn,
            hours: -diffHr,
            seconds: -diffSc,
          ),
        ),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: 'Your Custom Data',
      );
    }
  }
}
