import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {

  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if ( Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isDenied) {
        // 🔥 Abre la configuración para permitir alarmas exactas
        openAppSettings();
      }
    }
  }

  static Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid && (await AndroidAlarmManager.initialize()) == false) {
    await AndroidAlarmManager.initialize();
  }
}

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    if ( Platform.isAndroid) await requestExactAlarmPermission();
    await requestNotificationPermission();

    //Obtener zona horaria
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation( tz.getLocation( currentTimeZone ));


    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      requestBadgePermission: true,
      requestAlertPermission: true,
      requestSoundPermission: true,
    );


    InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosInitializationSettings
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("📩 Notificación tocada: ${response.payload}");
      },
    );
  }

  static NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Recordatorios',
        channelDescription: 'Canal para recordatorios',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Mostrar notificación inmediata
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {

    await flutterLocalNotificationsPlugin.show(
      id, 
      title, 
      body, 
      NotificationDetails(),
    );
  }

  // Programar notificación
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final now = DateTime.now();

    // 📌 Si la hora ya pasó hoy, mover la notificación al día siguiente
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint("⏳ Programando notificación para: ${scheduledDate.toLocal()}");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.time
    );
  }

  static Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    required DateTime scheduledDate,
  }) async {
    debugPrint(" Programando notificación repetitiva: $repeatInterval");

    final intervalo = repeatInterval.toString().split('.').first;

    switch ( intervalo ) {
      case 'Diario':
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time
        );
        break;
      case 'Semanal':
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
        );
        break;
    }

    // await flutterLocalNotificationsPlugin.periodicallyShow(
    //   id,
    //   title,
    //   body,
    //   repeatInterval,
    //   notificationDetails(),
    //   androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    // );
  }


  //! Arreglar el tiempo
  // tz.TZDateTime _nextInstanceOfDayAndTime(Day day, Time time) {
  //   tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
  //   while (scheduledDate.weekday != day.value) {
  //     scheduledDate = scheduledDate.add(Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

  // tz.TZDateTime _nextInstanceOfTime(Time time) {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

}
