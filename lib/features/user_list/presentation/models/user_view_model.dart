import '../../domain/entities/user.dart';

class UserViewModel {
  final int id;
  final String name;
  final String displayName; // UI-specific formatted name
  final bool isSelected; // UI state

  const UserViewModel({
    required this.id,
    required this.name,
    String? displayName,
    this.isSelected = false,
  }) : displayName = displayName ?? name;

  // Factory constructor to create ViewModel from Domain Entity
  factory UserViewModel.fromDomain(User user) {
    return UserViewModel(
      id: user.id,
      name: user.name,
      displayName: user.name, // You could add formatting here if needed
    );
  }

  // Create a copy with modified properties
  UserViewModel copyWith({
    int? id,
    String? name,
    String? displayName,
    bool? isSelected,
  }) {
    return UserViewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
