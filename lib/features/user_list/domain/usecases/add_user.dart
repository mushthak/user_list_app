import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class AddUser implements UseCase<User, String> {
  final UserRepository repository;

  AddUser(this.repository);

  @override
  Future<Either<Failure, User>> call(String name) {
    if (name.isEmpty) {
      return Future.value(Left(ValidationFailure('Name cannot be empty')));
    }
    return repository.addUser(name);
  }
}
