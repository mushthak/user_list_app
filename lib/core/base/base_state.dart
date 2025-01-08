import 'package:equatable/equatable.dart';

enum Status { initial, loading, success, failure }

abstract class BaseState extends Equatable {
  final Status status;
  final String? errorMessage;

  const BaseState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
}
