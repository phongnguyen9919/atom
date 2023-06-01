part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends LoginEvent {
  const Submitted();
}

class DomainNameChanged extends LoginEvent {
  const DomainNameChanged(this.domainName);

  final String domainName;

  @override
  List<Object> get props => [domainName];
}

class UsernameChanged extends LoginEvent {
  const UsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}
