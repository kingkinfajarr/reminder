import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../domain/models/reminder_model.dart';

class ReminderLocalDataSource {
  static final ReminderLocalDataSource _instance =
      ReminderLocalDataSource._internal();
  factory ReminderLocalDataSource() => _instance;
  ReminderLocalDataSource._internal();

  final String dbName = "reminders.db";
  final String tableName = "reminder";
  final String colId = "id";
  final String colTitle = "title";
  final String colDescription = "description";
  final String colHour = "hour";
  final String colMinute = "minute";

  Database? _db;

  Future<void> initDB() async {
    if (_db != null) return;

    String directory = await getDatabasesPath();
    String path = join(directory, dbName);

    _db = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
        "CREATE TABLE IF NOT EXISTS $tableName ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colHour INTEGER,$colMinute INTEGER)",
      );
    });
  }

  Future<void> insertReminder(Reminder reminder) async {
    await initDB();
    await _db?.insert(tableName, reminder.toMap());
  }

  Future<List<Reminder>> fetchAllReminders() async {
    await initDB();
    final List<Map<String, dynamic>> maps = await _db!.query(tableName);
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<void> updateReminder(Reminder reminder) async {
    await initDB();
    await _db?.update(
      tableName,
      reminder.toMap(),
      where: "$colId = ?",
      whereArgs: [reminder.id],
    );
  }

  Future<void> deleteReminder(int id) async {
    await initDB();
    await _db?.delete(
      tableName,
      where: "$colId = ?",
      whereArgs: [id],
    );
  }
}
