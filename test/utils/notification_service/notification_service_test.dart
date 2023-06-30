import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminder/utils/services/notification_service.dart';

@GenerateNiceMocks([
  MockSpec<FlutterLocalNotificationsPlugin>(),
  MockSpec<AndroidFlutterLocalNotificationsPlugin>(),
  MockSpec<IOSFlutterLocalNotificationsPlugin>()
])
import 'notification_service_test.mocks.dart';

void main() {
  late FlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;
  late AndroidFlutterLocalNotificationsPlugin
      mockAndroidFlutterLocalNotificationsPlugin;
  late IOSFlutterLocalNotificationsPlugin
      mockIOSFlutterLocalNotificationsPlugin;
  late NotificationService notificationServiceImpl;
  late NotificationService notificationService;

  setUp(() {
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    mockAndroidFlutterLocalNotificationsPlugin =
        MockAndroidFlutterLocalNotificationsPlugin();
    mockIOSFlutterLocalNotificationsPlugin =
        MockIOSFlutterLocalNotificationsPlugin();
    notificationServiceImpl = NotificationServiceImpl(
        flutterNotificationPlugin: mockFlutterLocalNotificationsPlugin);
    notificationService =
        NotificationService(notificationService: notificationServiceImpl);
  });

  test(
      "init should ask permissions and initialize flutter local notification plugin",
      () async {
    const permissionsAreGranted = true;

    when(mockFlutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestPermission())
        .thenAnswer((_) => Future.value(permissionsAreGranted));

    when(mockFlutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        )).thenAnswer((_) => Future.value(permissionsAreGranted));

    await notificationService.init();
  });

  test(
      "init should not initialize flutter local notification plugin if permissions are not granted",
      () async {
    const permissionsAreGranted = false;

    when(mockFlutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>())
        .thenReturn(mockAndroidFlutterLocalNotificationsPlugin);

    when(mockAndroidFlutterLocalNotificationsPlugin.requestPermission())
        .thenAnswer((_) => Future.value(permissionsAreGranted));

    // when(mockFlutterLocalNotificationsPlugin
    //         .resolvePlatformSpecificImplementation<
    //             IOSFlutterLocalNotificationsPlugin>())
    //     .thenReturn(mockIOSFlutterLocalNotificationsPlugin);
    //
    // when(mockIOSFlutterLocalNotificationsPlugin.requestPermissions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // )).thenAnswer((_) => Future.value(permissionsAreGranted));

    // when(mockFlutterLocalNotificationsPlugin
    //         .resolvePlatformSpecificImplementation<
    //             AndroidFlutterLocalNotificationsPlugin>()
    //         ?.requestPermission())
    //     // .thenReturn(Future.value(permissionsAreGranted));
    //     .thenAnswer((_) => Future.value(permissionsAreGranted));
    //
    // when(mockFlutterLocalNotificationsPlugin
    //         .resolvePlatformSpecificImplementation<
    //             IOSFlutterLocalNotificationsPlugin>()
    //         ?.requestPermissions(
    //           alert: true,
    //           badge: true,
    //           sound: true,
    //         ))
    //     // .thenReturn(Future.value(permissionsAreGranted));
    //     .thenAnswer((_) => Future.value(permissionsAreGranted));

    await notificationService.init();

    verify(mockAndroidFlutterLocalNotificationsPlugin.requestPermission())
        .called(1);

    verify(mockIOSFlutterLocalNotificationsPlugin.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    )).called(1);

    verifyNever(mockFlutterLocalNotificationsPlugin
        .initialize(NotificationService.initializationSettings));
  });
}
