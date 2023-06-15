import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'data/database/database.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final callback = Callback(
    onCreate: (database, version) { print("database is created"); },
    onOpen: (database) { /* database has been opened */ },
    onUpgrade: (database, startVersion, endVersion) { print("\n\nStart Version: $startVersion \nEnd Version: $endVersion"); },
  );

  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').addCallback(callback).build();

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
