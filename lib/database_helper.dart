import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'fish.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._(); // Private constructor

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'aquarium.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fishCount INTEGER,
        speed REAL,
        color INTEGER
      )
    ''');
  }

  // Save settings to database
  Future<void> saveSettings(int fishCount, double speed, int color) async {
    final db = await database;
    await db.insert(
      'settings',
      {'fishCount': fishCount, 'speed': speed, 'color': color},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Load settings from database
  Future<Map<String, dynamic>> loadSettings() async {
    final db = await database;
    final result = await db.query('settings', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return {};
  }

  // Clear the settings (optional)
  Future<void> clearSettings() async {
    final db = await database;
    await db.delete('settings');
  }
}
