import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(String name);
  Future<void> deleteUser(int id);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  late Database _database;
  static const String tableName = 'users';
  bool _isInitialized = false;
  final _logger = Logger();

  UserLocalDataSourceImpl();

  // Test constructor
  UserLocalDataSourceImpl.test(Database database) {
    _database = database;
    _isInitialized = true;
  }

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'user_database.db');

      _database = await openDatabase(
        path,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
          );
        },
        version: 1,
      );

      _isInitialized = true;
    } catch (e) {
      _logger.e('Database initialization error', error: e);
      rethrow;
    }
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError('Database not initialized. Call init() first.');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    _checkInitialized();
    try {
      final List<Map<String, dynamic>> maps = await _database.query(tableName);
      return List.generate(maps.length, (i) => UserModel.fromJson(maps[i]));
    } catch (e) {
      _logger.e('Error getting users', error: e);
      rethrow;
    }
  }

  @override
  Future<UserModel> addUser(String name) async {
    _checkInitialized();
    try {
      final id = await _database.insert(
        tableName,
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return UserModel(id: id, name: name);
    } catch (e) {
      _logger.e('Error adding user', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    _checkInitialized();
    try {
      await _database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e('Error deleting user', error: e);
      rethrow;
    }
  }
}
