import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static final DB _instance = DB._internal();
  factory DB() => _instance;
  DB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE watched_videos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        videoId TEXT NOT NULL,
        title TEXT,
        thumbnailUrl TEXT,
        channelName TEXT,
        publishedAt TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(userId) REFERENCES users(id)
      );
    ''');
  }

  Future<int> insertUser(String email) async {
    final db = await DB().database;
    return await db.insert(
      'users',
      {'email': email},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertOrReplaceWatchedVideoWithEmail({
    required String email,
    required String videoId,
    required String title,
    required String thumbnailUrl,
    required String channelName,
    required String publishedAt,
  }) async {
    final db = await DB().database;

    int userId = await _getOrInsertUserId(email, db);

    await db.delete(
      'watched_videos',
      where: 'userId = ? AND videoId = ?',
      whereArgs: [userId, videoId],
    );

    await db.insert('watched_videos', {
      'userId': userId,
      'videoId': videoId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'channelName': channelName,
      'publishedAt': publishedAt,
    });
  }

  Future<int> _getOrInsertUserId(String email, Database db) async {
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }

    return await db.insert(
      'users',
      {'email': email},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    ).then((id) async {
      if (id != 0) return id;

      final existing = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return existing.first['id'] as int;
    });
  }

  Future<List<Map<String, dynamic>>> getWatchedVideosByEmail(String email) async {
    final db = await DB().database;

    final userResult = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (userResult.isEmpty) {
      return [];
    }

    final userId = userResult.first['id'] as int;

    final videoList = await db.query(
      'watched_videos',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return videoList;
  }

}
