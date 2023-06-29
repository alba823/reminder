// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class NotificationService {
  static NotificationService? _notificationService;

  factory NotificationService({NotificationService? notificationService}) {
    _notificationService ??= notificationService ?? NotificationServiceImpl();
    return _notificationService!;
  }

  abstract NotificationPermissionState _permissionState;
  NotificationPermissionState getPermissionState();

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
  NotificationPermissionState _permissionState = NotificationPermissionState.idle;

  @override
  NotificationPermissionState getPermissionState() => _permissionState;

  @override
  Future<void> scheduleNotification(
      {required int notificationId,
      required String text,
      required DateTime dateTime}) async {

    final localDateTime = tz.TZDateTime.from(dateTime, tz.local);
    if (localDateTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (pendingNotifications.any((element) => element.id == notificationId)) {
      await removeNotification(notificationId: notificationId);
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(notificationId,
        _notificationTitle, text, localDateTime, notificationDetails,
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

    await getUpdatedPermissionState();

    if (_permissionState == NotificationPermissionState.denied) return;

    await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
    );
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
    _permissionState = await _askPermissionsAndGetTheirState()
        ? NotificationPermissionState.granted
        : NotificationPermissionState.denied;

    return _permissionState;
  }
}

// region Consts

const androidNotificationDetails = AndroidNotificationDetails(
    'Reminder channel id', 'reminder notifications channel',
    channelDescription: 'Channel of your reminder app',
    importance: Importance.max,
    priority: Priority.high);

const darwinNotificationDetails = DarwinNotificationDetails();

const notificationDetails = NotificationDetails(
    android: androidNotificationDetails, iOS: darwinNotificationDetails);


const _initializationSettingsAndroid =
AndroidInitializationSettings('app_icon');

const _initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true);

const _initializationSettings = InitializationSettings(
  android: _initializationSettingsAndroid,
  iOS: _initializationSettingsIOS,
);

const _notificationTitle = "Don't forget about your task";

// endregion Consts