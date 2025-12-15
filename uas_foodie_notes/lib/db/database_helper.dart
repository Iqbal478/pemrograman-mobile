import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foodie_notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      recipeId TEXT NOT NULL,
      content TEXT NOT NULL
    )
    ''');
  }

  // 1. CREATE (Simpan)
  Future<int> create(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  // 2. READ (Baca)
  Future<List<Note>> readNotes(String recipeId) async {
    final db = await instance.database;
    final maps = await db.query(
      'notes',
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Note(
        id: json['id'] as int,
        recipeId: json['recipeId'] as String,
        content: json['content'] as String,
      )).toList();
    } else {
      return [];
    }
  }

  // 3. UPDATE (Edit) <--- INI YANG TADINYA HILANG
  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // 4. DELETE (Hapus)
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}