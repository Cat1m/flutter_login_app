import 'package:flutter_login_app/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "myDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnUsername = 'username';
  static const columnAppVer = 'appver';
  static const columnToken = 'token';
  static const columnDeviceId = 'deviceid';

  // Tạo một private constructor
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          id INTEGER PRIMARY KEY,
          $columnUsername TEXT NOT NULL,
          $columnAppVer TEXT NOT NULL,
          $columnToken TEXT NOT NULL,
          $columnDeviceId TEXT
        )
        ''');
  }

  Future<int> insert(User user) async {
    Database db = await database;
    return await db.insert(table, user.toMap());
  }

  Future<List<Map<String, Object?>>> queryAllRows() async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Phương thức để cập nhật dữ liệu
  Future<void> updateData(User user) async {
    // Kiểm tra xem bảng có dữ liệu không
    List<Map<String, Object?>> existingData = await queryAllRows();

    // Nếu bảng có dữ liệu, xóa tất cả dữ liệu
    if (existingData.isNotEmpty) {
      await deleteAll();
    }

    // Thêm dữ liệu mới vào bảng
    await insert(user);
  }

  // Phương thức để xóa tất cả dữ liệu trong bảng
  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM $table');
  }

  //truy vấn dữ liệu và trả về 1 users list

  Future<List<User>> fetchDataAsUsers() async {
    final queryResult = await queryAllRows();
    final users = queryResult.map((map) => User.fromMap(map)).toList();
    return users;
  }
}
