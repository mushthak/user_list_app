import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:user_list_app/features/user_list/data/datasources/user_local_data_source.dart';
import 'package:user_list_app/features/user_list/data/models/user_model.dart';

void main() {
  late UserLocalDataSourceImpl dataSource;
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Use in-memory database for testing
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
          );
        },
      ),
    );

    dataSource = UserLocalDataSourceImpl.test(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('should initialize database successfully', () async {
    // Act & Assert
    expect(dataSource, isNotNull);
  });

  group('getUsers', () {
    test('should return empty list when no users exist', () async {
      // Act
      final result = await dataSource.getUsers();

      // Assert
      expect(result, isEmpty);
    });

    test('should return list of users when users exist', () async {
      // Arrange
      final user = await dataSource.addUser('Test User');

      // Act
      final result = await dataSource.getUsers();

      // Assert
      expect(result, [user]);
    });
  });

  group('addUser', () {
    test('should add user successfully', () async {
      // Act
      final result = await dataSource.addUser('Test User');

      // Assert
      expect(result.name, 'Test User');
      expect(result.id, isNotNull);
    });

    test('should add multiple users with unique ids', () async {
      // Act
      final user1 = await dataSource.addUser('User 1');
      final user2 = await dataSource.addUser('User 2');

      // Assert
      expect(user1.id, isNot(user2.id));
      expect(user1.name, 'User 1');
      expect(user2.name, 'User 2');
    });
  });

  group('deleteUser', () {
    test('should delete user successfully', () async {
      // Arrange
      final user = await dataSource.addUser('Test User');
      final users = await dataSource.getUsers();
      expect(users, contains(user));

      // Act
      await dataSource.deleteUser(user.id);
      final updatedUsers = await dataSource.getUsers();

      // Assert
      expect(updatedUsers, isEmpty);
    });

    test('should not throw error when deleting non-existent user', () async {
      // Act & Assert
      expect(() => dataSource.deleteUser(999), returnsNormally);
    });
  });

  test('should throw StateError when not initialized', () async {
    // Arrange
    final uninitializedDataSource = UserLocalDataSourceImpl();

    // Act & Assert
    expect(() => uninitializedDataSource.getUsers(), throwsStateError);
    expect(() => uninitializedDataSource.addUser('Test'), throwsStateError);
    expect(() => uninitializedDataSource.deleteUser(1), throwsStateError);
  });
}
