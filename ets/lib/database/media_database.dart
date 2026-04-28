import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MediaDatabase {
  static final MediaDatabase instance =
      MediaDatabase();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database!;

    _database = await initDB("media.db");
    return _database!;
  }

  Future<Database> initDB(
      String filePath) async {
    final dbPath =
        await getDatabasesPath();

    final path =
        join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: createDB,
    );
  }

  Future createDB(
      Database db,
      int version) async {
    await db.execute('''
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        createdAt TEXT
      )
    ''');
  }

  Future<int> insertImage(
      String path) async {
    final db = await instance.database;

    return await db.insert(
      "media",
      {
        "path": path,
        "createdAt":
            DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getImages() async {
    final db = await instance.database;

    return await db.query(
      "media",
      orderBy: "id DESC",
    );
  }

  Future<int> deleteImage(int id) async {
    final db = await instance.database;

    return await db.delete(
      "media",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}