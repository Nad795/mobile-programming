import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MediaDatabase {
  static final MediaDatabase instance =
      MediaDatabase();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

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
      version: 2,
      onCreate: createDB,
      onUpgrade: upgradeDB,
    );
  }

  Future<void> createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        source TEXT NOT NULL,
        room TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<void> upgradeDB(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    await db.execute(
        "DROP TABLE IF EXISTS media");

    await createDB(db, newVersion);
  }

  Future<int> insertImage(
    String path, {
    String source = "camera",
    String room = "",
  }) async {
    final db = await instance.database;

    return await db.insert(
      "media",
      {
        "path": path,
        "source": source,
        "room": room,
        "createdAt": DateTime.now()
            .toIso8601String(),
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

  Future<List<Map<String, dynamic>>>
      getImagesByRoom(
          String room) async {
    final db = await instance.database;

    return await db.query(
      "media",
      where: "room = ?",
      whereArgs: [room],
      orderBy: "id DESC",
    );
  }

  Future<List<Map<String, dynamic>>>
      getImagesBySource(
          String source) async {
    final db = await instance.database;

    return await db.query(
      "media",
      where: "source = ?",
      whereArgs: [source],
      orderBy: "id DESC",
    );
  }

  Future<int> deleteImage(
      int id) async {
    final db = await instance.database;

    return await db.delete(
      "media",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}