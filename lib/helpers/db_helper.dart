import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('sales_tasks.db');
    return _db!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        shopName TEXT,
        productSold TEXT,
        quantity INTEGER,
        amount REAL,
        notes TEXT,
        timestamp TEXT,
        isSynced INTEGER
      )
    ''');
  }

  static Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  static Future<List<Task>> getUnsyncedTasks() async {
    final db = await database;
    final result = await db.query('tasks', where: 'isSynced = ?', whereArgs: [0]);
    return result.map((map) => Task.fromMap(map)).toList();
  }

  static Future<void> markTaskAsSynced(String id) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> clearAllTasks() async {
    final db = await database;
    await db.delete('tasks');
  }
}
