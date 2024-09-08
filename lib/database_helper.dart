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
          CREATE TABLE document_types (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE vendors (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
        // Insert initial data
        await db.insert('projects', {'name': 'des ecluses'});
        await db.insert('projects', {'name': 'compica'});
        await db.insert('projects', {'name': 'saint-Laurent'});
        await db.insert('projects', {'name': 'edouard'});
        await db.insert('projects', {'name': 'des cigales'});
        await db.insert('document_types', {'name': 'document'});
        await db.insert('document_types', {'name': 'facture'});
        await db.insert('document_types', {'name': 'identification'});
        await db.insert('vendors', {'name': 'scotiabank'});
        await db.insert('vendors', {'name': 'visa mbna'});
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

  Future<List<String>> getDocumentTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('document_types');
    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }

  Future<List<String>> getVendors() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vendors');
    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }

  Future<void> insertProject(String name) async {
    final db = await database;
    await db.insert('projects', {'name': name});
  }

  Future<void> updateProject(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'projects',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> insertDocumentType(String name) async {
    final db = await database;
    await db.insert('document_types', {'name': name});
  }

  Future<void> updateDocumentType(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'document_types',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> insertVendor(String name) async {
    final db = await database;
    await db.insert('vendors', {'name': name});
  }

  Future<void> updateVendor(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'vendors',
      {'name': newName},
      where: 'name = ?',
      whereArgs: [oldName],
    );
  }
}