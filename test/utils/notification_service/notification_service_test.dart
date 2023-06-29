import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:reminder/utils/services/notification_service.dart';

@GenerateNiceMocks([MockSpec<FlutterLocalNotificationsPlugin>()])
import 'notification_service_test.mocks.dart';

void main() {
  late FlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;
  late NotificationService notificationServiceImpl;
  late NotificationService notificationService;

  setUp(() {
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    notificationServiceImpl = NotificationServiceImpl(flutterNotificationPlugin: mockFlutterLocalNotificationsPlugin);
    notificationService = NotificationService(notificationService: notificationServiceImpl);
  });

  test("init should ", () async {
    await notificationService.init();


  });
}
