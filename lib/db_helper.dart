import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:subspace_assignment/Models/blog.dart';

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
    String path = join(await getDatabasesPath(), 'blog_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE blogs(id TEXT PRIMARY KEY, title TEXT, imageUrl TEXT, category TEXT, isFavorite INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertBlog(Blog blog) async {
    final db = await database;
    await db.insert(
      'blogs',
      blog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Blog>> blogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('blogs');
    return List.generate(maps.length, (i) {
      return Blog.fromMap(maps[i]);
    });
  }

  Future<void> updateBlog(Blog blog) async {
    final db = await database;
    await db.update(
      'blogs',
      blog.toMap(),
      where: "id = ?",
      whereArgs: [blog.id],
    );
  }

  Future<void> deleteBlog(String id) async {
    final db = await database;
    await db.delete(
      'blogs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
