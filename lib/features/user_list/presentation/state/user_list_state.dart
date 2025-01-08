import 'package:equatable/equatable.dart';
import '../models/user_view_model.dart';

enum UserListStatus { initial, loading, success, failure }

class UserListState extends Equatable {
  final List<UserViewModel> users;
  final UserListStatus status;
  final String? errorMessage;

  const UserListState({
    this.users = const [],
    this.status = UserListStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [users, status, errorMessage];

  UserListState copyWith({
    List<UserViewModel>? users,
    UserListStatus? status,
    String? errorMessage,
  }) {
    return UserListState(
      users: users ?? this.users,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
