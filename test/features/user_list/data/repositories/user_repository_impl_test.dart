import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:user_list_app/core/error/failures.dart';
import 'package:user_list_app/features/user_list/data/datasources/user_local_data_source.dart';
import 'package:user_list_app/features/user_list/data/models/user_model.dart';
import 'package:user_list_app/features/user_list/data/repositories/user_repository_impl.dart';

@GenerateNiceMocks([MockSpec<UserLocalDataSource>()])
import 'user_repository_impl_test.mocks.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('getUsers', () {
    final tUsers = [
      const UserModel(id: 1, name: 'Test User 1'),
      const UserModel(id: 2, name: 'Test User 2'),
    ];

    test(
      'should return list of users when local data source is successful',
      () async {
        // arrange
        when(mockLocalDataSource.getUsers()).thenAnswer((_) async => tUsers);

        // act
        final result = await repository.getUsers();

        // assert
        verify(mockLocalDataSource.getUsers());
        expect(result, equals(Right(tUsers)));
      },
    );

    test(
      'should return DatabaseFailure when local data source throws',
      () async {
        // arrange
        when(mockLocalDataSource.getUsers()).thenThrow(Exception());

        // act
        final result = await repository.getUsers();

        // assert
        verify(mockLocalDataSource.getUsers());
        expect(
            result,
            equals(const Left(
                DatabaseFailure('Failed to fetch users: Exception'))));
      },
    );
  });

  group('addUser', () {
    const tName = 'Test User';
    const tUser = UserModel(id: 1, name: tName);

    test(
      'should return user when local data source is successful',
      () async {
        // arrange
        when(mockLocalDataSource.addUser(any)).thenAnswer((_) async => tUser);

        // act
        final result = await repository.addUser(tName);

        // assert
        verify(mockLocalDataSource.addUser(tName));
        expect(result, equals(const Right(tUser)));
      },
    );

    test(
      'should return DatabaseFailure when local data source throws',
      () async {
        // arrange
        when(mockLocalDataSource.addUser(any)).thenThrow(Exception());

        // act
        final result = await repository.addUser(tName);

        // assert
        verify(mockLocalDataSource.addUser(tName));
        expect(
            result,
            equals(
                const Left(DatabaseFailure('Failed to add user: Exception'))));
      },
    );
  });

  group('deleteUser', () {
    const tId = 1;

    test(
      'should return void when local data source is successful',
      () async {
        // arrange
        when(mockLocalDataSource.deleteUser(any)).thenAnswer((_) async => {});

        // act
        final result = await repository.deleteUser(tId);

        // assert
        verify(mockLocalDataSource.deleteUser(tId));
        expect(result, equals(const Right(null)));
      },
    );

    test(
      'should return DatabaseFailure when local data source throws',
      () async {
        // arrange
        when(mockLocalDataSource.deleteUser(any)).thenThrow(Exception());

        // act
        final result = await repository.deleteUser(tId);

        // assert
        verify(mockLocalDataSource.deleteUser(tId));
        expect(
            result,
            equals(const Left(
                DatabaseFailure('Failed to delete user: Exception'))));
      },
    );
  });
}
