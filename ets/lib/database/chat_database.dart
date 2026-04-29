import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabase {
  static final ChatDatabase instance =
      ChatDatabase();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB("chat.db");

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

  Future createDB(
      Database db,
      int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room TEXT NOT NULL,
        text TEXT NOT NULL,
        isMe INTEGER NOT NULL
      )
    ''');
  }

  Future upgradeDB(
      Database db,
      int oldVersion,
      int newVersion) async {
    await db.execute(
        "DROP TABLE IF EXISTS messages");

    await createDB(db, newVersion);
  }

  Future<int> insertMessage(
    String room,
    String text,
    bool isMe,
  ) async {
    final db = await instance.database;

    return await db.insert(
      "messages",
      {
        "room": room,
        "text": text,
        "isMe": isMe ? 1 : 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getMessages() async {
    final db = await instance.database;

    return await db.query(
      "messages",
      orderBy: "id ASC",
    );
  }

  Future<int> deleteMessage(
      int id) async {
    final db = await instance.database;

    return await db.delete(
      "messages",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateMessage(
    int id,
    String newText,
  ) async {
    final db = await instance.database;

    return await db.update(
      "messages",
      {
        "text": newText,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
}