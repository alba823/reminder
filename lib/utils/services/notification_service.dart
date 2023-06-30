// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class NotificationService {
  static NotificationService? _notificationService;
  static InitializationSettings initializationSettings =
      const InitializationSettings(
    android: _initializationSettingsAndroid,
    iOS: _initializationSettingsIOS,
  );

  factory NotificationService({NotificationService? notificationService}) {
    _notificationService ??= notificationService ?? NotificationServiceImpl();
    return _notificationService!;
  }

  Future<void> init();

  Future<NotificationPermissionState> getUpdatedPermissionState();

  Future<void> scheduleNotification(
      {required int notificationId,
      required String text,
      required DateTime dateTime});

  Future<void> removeNotification({required int notificationId});
}

enum NotificationPermissionState { idle, granted, denied }

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationServiceImpl(
      {FlutterLocalNotificationsPlugin? flutterNotificationPlugin})
      : _flutterLocalNotificationsPlugin =
            flutterNotificationPlugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> scheduleNotification(
      {required int notificationId,
      required String text,
      required DateTime dateTime}) async {
    final localDateTime = tz.TZDateTime.from(dateTime, tz.local);
    if (localDateTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    final pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (pendingNotifications.any((element) => element.id == notificationId)) {
      await removeNotification(notificationId: notificationId);
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(notificationId,
        _notificationTitle, text, localDateTime, _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Future<void> removeNotification({required int notificationId}) async {
    return _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  @override
  Future<void> init() async {
    tz.initializeTimeZones();

    if (await getUpdatedPermissionState() == NotificationPermissionState.denied) return;

    await _flutterLocalNotificationsPlugin
        .initialize(NotificationService.initializationSettings);
  }

  Future<bool> _askPermissionsAndGetTheirState() async {
    final isAndroidPermissionGranted = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    final isIOSPermissionGranted = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return (isAndroidPermissionGranted ?? true) &&
        (isIOSPermissionGranted ?? true);
  }

  @override
  Future<NotificationPermissionState> getUpdatedPermissionState() async {
    return await _askPermissionsAndGetTheirState()
        ? NotificationPermissionState.granted
        : NotificationPermissionState.denied;
  }
}

// region Consts

const _androidNotificationDetails = AndroidNotificationDetails(
    'Reminder channel id', 'reminder notifications channel',
    channelDescription: 'Channel of your reminder app',
    importance: Importance.max,
    priority: Priority.high);

const _darwinNotificationDetails = DarwinNotificationDetails();

const _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails, iOS: _darwinNotificationDetails);

const _initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

const _initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true);

const _notificationTitle = "Don't forget about your task";

// endregion Consts
