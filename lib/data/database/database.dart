// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:reminder/data/database/datetime_converter.dart';
import 'package:reminder/data/database/event_dao.dart';
import 'package:reminder/data/database/event.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Event])
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
   EventDao get eventDao;
}