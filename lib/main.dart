import 'package:flutter/material.dart';
import 'package:reminder/utils/services/notification_service.dart';

import 'data/database/database.dart';
import 'ui/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();
  final database = await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return RepositoryProviderWidget(eventDao: database.eventDao);
  }
}
