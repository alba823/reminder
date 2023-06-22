import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class NotificationService {
  static NotificationService? _notificationService;

  factory NotificationService({NotificationService? notificationService}) {
    _notificationService ??= notificationService ?? NotificationServiceImpl();
    return _notificationService!;
  }

  Future<void> init();

  Future<void> scheduleNotification(
      {required int notificationId,
      required String text,
      required DateTime dateTime});


}

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationServiceImpl(
      {FlutterLocalNotificationsPlugin? flutterNotificationPlugin})
      : flutterLocalNotificationsPlugin =
            flutterNotificationPlugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> scheduleNotification(
      {required int notificationId,
      required String text,
      required DateTime dateTime}) async {
    const androidNotificationDetails = AndroidNotificationDetails(
        'Reminder channel id', 'reminder notifications channel',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const darwinNotificationDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    final localDateTime = tz.TZDateTime.from(dateTime, tz.local);
    print(
        "wont show notifications: ${localDateTime.isBefore(tz.TZDateTime.now(tz.local))}");
    if (localDateTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, _notificationTitle, text, localDateTime, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Future<void> init() async {
    tz.initializeTimeZones();
    await _ensureThatPermissionsAreGranted();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true);

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _ensureThatPermissionsAreGranted() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

const _notificationTitle = "Test Notification";
