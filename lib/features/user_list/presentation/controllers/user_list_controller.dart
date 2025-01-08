import 'package:flutter/foundation.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_view_model.dart';
import '../state/user_list_state.dart';

class UserListController extends ChangeNotifier {
  final UserRepository _repository;
  UserListState _state = const UserListState();

  UserListController(this._repository);

  UserListState get state => _state;

  Future<void> loadUsers() async {
    _state = _state.copyWith(status: UserListStatus.loading);
    notifyListeners();

    final result = await _repository.getUsers();
    result.fold(
      (failure) {
        _state = _state.copyWith(
          status: UserListStatus.failure,
          errorMessage: 'Failed to load users',
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

    final result = await _repository.addUser(name);
    result.fold(
      (failure) {
        _state = _state.copyWith(
          errorMessage: 'Failed to add user',
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
    final result = await _repository.deleteUser(id);
    result.fold(
      (failure) {
        _state = _state.copyWith(
          errorMessage: 'Failed to delete user',
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
