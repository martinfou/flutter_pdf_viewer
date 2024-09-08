import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE projects (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE options (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
        // Insert initial data
        await db.insert('projects', {'name': 'des ecluses'});
        await db.insert('projects', {'name': 'compica'});
        await db.insert('projects', {'name': 'saint-Laurent'});
        await db.insert('projects', {'name': 'edouard'});
        await db.insert('options', {'name': 'document'});
        await db.insert('options', {'name': 'facture'});
        await db.insert('options', {'name': 'identification'});
      },
    );
  }

  Future<List<String>> getProjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('projects');
    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }

  Future<List<String>> getOptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('options');
    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }
}