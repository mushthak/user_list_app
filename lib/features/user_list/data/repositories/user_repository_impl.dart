import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await localDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(DatabaseFailure('Failed to fetch users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> addUser(String name) async {
    try {
      final user = await localDataSource.addUser(name);
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Failed to add user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    try {
      await localDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete user: ${e.toString()}'));
    }
  }
}
