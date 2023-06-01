part of 'user_edit_bloc.dart';

abstract class UserEditEvent extends Equatable {
  const UserEditEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends UserEditEvent {
  const Submitted();
}

class UsernameChanged extends UserEditEvent {
  const UsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class PasswordChanged extends UserEditEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class IsEditChanged extends UserEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
