// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EventDao? _eventDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `events` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `isChecked` INTEGER NOT NULL, `timeStamp` INTEGER NOT NULL, `date` TEXT NOT NULL, `notificationId` INTEGER NOT NULL, `shouldShowNotification` INTEGER NOT NULL)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_events_id` ON `events` (`id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EventDao get eventDao {
    return _eventDaoInstance ??= _$EventDao(database, changeListener);
  }
}

class _$EventDao extends EventDao {
  _$EventDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _eventInsertionAdapter = InsertionAdapter(
            database,
            'events',
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isChecked': item.isChecked ? 1 : 0,
                  'timeStamp': _dateTimeConverter.encode(item.timeStamp),
                  'date': item.date,
                  'notificationId': item.notificationId,
                  'shouldShowNotification': item.shouldShowNotification ? 1 : 0
                }),
        _eventUpdateAdapter = UpdateAdapter(
            database,
            'events',
            ['id'],
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isChecked': item.isChecked ? 1 : 0,
                  'timeStamp': _dateTimeConverter.encode(item.timeStamp),
                  'date': item.date,
                  'notificationId': item.notificationId,
                  'shouldShowNotification': item.shouldShowNotification ? 1 : 0
                }),
        _eventDeletionAdapter = DeletionAdapter(
            database,
            'events',
            ['id'],
            (Event item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isChecked': item.isChecked ? 1 : 0,
                  'timeStamp': _dateTimeConverter.encode(item.timeStamp),
                  'date': item.date,
                  'notificationId': item.notificationId,
                  'shouldShowNotification': item.shouldShowNotification ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Event> _eventInsertionAdapter;

  final UpdateAdapter<Event> _eventUpdateAdapter;

  final DeletionAdapter<Event> _eventDeletionAdapter;

  @override
  Future<List<Event>> getAllEvents() async {
    return _queryAdapter.queryList('SELECT * FROM events',
        mapper: (Map<String, Object?> row) => Event(
            row['id'] as int?,
            row['name'] as String,
            (row['isChecked'] as int) != 0,
            _dateTimeConverter.decode(row['timeStamp'] as int),
            row['date'] as String,
            row['notificationId'] as int,
            (row['shouldShowNotification'] as int) != 0));
  }

  @override
  Future<List<Event>> getEventsByDateTime(String dateTime) async {
    return _queryAdapter.queryList('SELECT * FROM events WHERE date == ?1',
        mapper: (Map<String, Object?> row) => Event(
            row['id'] as int?,
            row['name'] as String,
            (row['isChecked'] as int) != 0,
            _dateTimeConverter.decode(row['timeStamp'] as int),
            row['date'] as String,
            row['notificationId'] as int,
            (row['shouldShowNotification'] as int) != 0),
        arguments: [dateTime]);
  }

  @override
  Future<void> insertEvent(Event event) async {
    await _eventInsertionAdapter.insert(event, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertEvents(List<Event> events) async {
    await _eventInsertionAdapter.insertList(events, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEvent(Event event) async {
    await _eventUpdateAdapter.update(event, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteEvent(Event event) async {
    await _eventDeletionAdapter.delete(event);
  }

  @override
  Future<void> deleteEvents(List<Event> events) async {
    await _eventDeletionAdapter.deleteList(events);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
