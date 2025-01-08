import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:user_list_app/core/error/failures.dart';
import 'package:user_list_app/features/user_list/domain/entities/user.dart';
import 'package:user_list_app/features/user_list/domain/repositories/user_repository.dart';
import 'package:user_list_app/features/user_list/presentation/controllers/user_list_controller.dart';
import 'package:user_list_app/features/user_list/presentation/state/user_list_state.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'user_list_controller_test.mocks.dart';

void main() {
  late UserListController controller;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    controller = UserListController(mockRepository);
  });

  group('loadUsers', () {
    final tUsers = [
      const User(id: 1, name: 'Test 1'),
      const User(id: 2, name: 'Test 2'),
    ];

    test('should update state to loading then success when repository succeeds',
        () async {
      // arrange
      when(mockRepository.getUsers()).thenAnswer((_) async => Right(tUsers));

      // act
      await controller.loadUsers();

      // assert
      verify(mockRepository.getUsers());
      expect(controller.state.users.length, equals(2));
      expect(controller.state.status, equals(UserListStatus.success));
    });

    test('should update state to loading then failure when repository fails',
        () async {
      // arrange
      when(mockRepository.getUsers())
          .thenAnswer((_) async => Left(DatabaseFailure()));

      // act
      await controller.loadUsers();

      // assert
      verify(mockRepository.getUsers());
      expect(controller.state.status, equals(UserListStatus.failure));
      expect(controller.state.errorMessage, equals('Failed to load users'));
    });
  });

  group('addUser', () {
    const tName = 'Test User';
    const tUser = User(id: 1, name: tName);

    test('should add user to state when repository succeeds', () async {
      // arrange
      when(mockRepository.addUser(any))
          .thenAnswer((_) async => const Right(tUser));

      // act
      await controller.addUser(tName);

      // assert
      verify(mockRepository.addUser(tName));
      expect(controller.state.users.length, equals(1));
      expect(controller.state.users.first.name, equals(tName));
    });

    test('should update error message when repository fails', () async {
      // arrange
      when(mockRepository.addUser(any))
          .thenAnswer((_) async => Left(DatabaseFailure()));

      // act
      await controller.addUser(tName);

      // assert
      verify(mockRepository.addUser(tName));
      expect(controller.state.errorMessage, equals('Failed to add user'));
    });
  });

  group('deleteUser', () {
    const tId = 1;

    test('should remove user from state when repository succeeds', () async {
      // arrange
      when(mockRepository.deleteUser(any))
          .thenAnswer((_) async => const Right(null));

      // First add a user to delete
      const tUser = User(id: tId, name: 'Test');
      when(mockRepository.addUser(any))
          .thenAnswer((_) async => const Right(tUser));
      await controller.addUser('Test');

      // act
      await controller.deleteUser(tId);

      // assert
      verify(mockRepository.deleteUser(tId));
      expect(controller.state.users.length, equals(0));
    });

    test('should update error message when repository fails', () async {
      // arrange
      when(mockRepository.deleteUser(any))
          .thenAnswer((_) async => Left(DatabaseFailure()));

      // act
      await controller.deleteUser(tId);

      // assert
      verify(mockRepository.deleteUser(tId));
      expect(controller.state.errorMessage, equals('Failed to delete user'));
    });
  });
}
