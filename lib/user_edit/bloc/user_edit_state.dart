part of 'user_edit_bloc.dart';

enum UserEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension UserEditStatusX on UserEditStatus {
  bool isWaiting() => this == UserEditStatus.waiting;
  bool isSuccess() => this == UserEditStatus.success;
  bool isFailure() => this == UserEditStatus.failure;
}

class UserEditState extends Equatable {
  const UserEditState({
    required this.isAdmin,
    required this.domain,
    this.status = UserEditStatus.normal,
    required this.isEdit,
    this.username = '',
    this.password = '',
    this.initialUser,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;

  // initial
  final User? initialUser;

  // input
  final String username;
  final String password;

  // status
  final UserEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props =>
      [isAdmin, domain, isEdit, initialUser, username, password, status, error];

  UserEditState copyWith({
    bool? isAdmin,
    String? domain,
    String? username,
    String? password,
    bool? isEdit,
    UserEditStatus? status,
    User? initialUser,
    String? Function()? error,
  }) {
    return UserEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      domain: domain ?? this.domain,
      username: username ?? this.username,
      password: password ?? this.password,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialUser: initialUser ?? this.initialUser,
      error: error != null ? error() : this.error,
    );
  }
}
