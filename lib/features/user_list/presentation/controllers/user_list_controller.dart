import '../../../../core/base/base_view_model.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_users.dart';
import '../models/user_view_model.dart';
import '../state/user_list_state.dart';

class UserListController extends BaseViewModel {
  final GetUsers _getUsers;
  final AddUser _addUser;
  final DeleteUser _deleteUser;
  UserListState _state = const UserListState();

  UserListController({
    required GetUsers getUsers,
    required AddUser addUser,
    required DeleteUser deleteUser,
  })  : _getUsers = getUsers,
        _addUser = addUser,
        _deleteUser = deleteUser;

  UserListState get state => _state;

  Future<void> loadUsers() async {
    _state = _state.copyWith(status: UserListStatus.loading);
    notifyListeners();

    final result = await _getUsers(const NoParams());
    result.fold(
      (failure) {
        _state = _state.copyWith(
          status: UserListStatus.failure,
          errorMessage: failure.message,
        );
      },
      (users) {
        _state = _state.copyWith(
          status: UserListStatus.success,
          users: users.map((user) => UserViewModel.fromDomain(user)).toList(),
        );
      },
    );
    notifyListeners();
  }

  Future<void> addUser(String name) async {
    if (name.isEmpty) return;

    final result = await _addUser(name);
    result.fold(
      (failure) {
        _state = _state.copyWith(
          errorMessage: failure.message,
        );
      },
      (user) {
        final newUser = UserViewModel.fromDomain(user);
        _state = _state.copyWith(
          users: [..._state.users, newUser],
        );
      },
    );
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    final result = await _deleteUser(id);
    result.fold(
      (failure) {
        _state = _state.copyWith(
          errorMessage: failure.message,
        );
      },
      (_) {
        _state = _state.copyWith(
          users: _state.users.where((user) => user.id != id).toList(),
        );
      },
    );
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }
}
