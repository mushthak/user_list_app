import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';

class DeleteUser implements UseCase<void, int> {
  final UserRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) {
    if (id <= 0) {
      return Future.value(const Left(ValidationFailure('Invalid user ID')));
    }
    return repository.deleteUser(id);
  }
}
