part of 'signup_bloc.dart';

class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends SignupEvent {
  const Submitted();
}

class DomainNameChanged extends SignupEvent {
  const DomainNameChanged(this.domainName);

  final String domainName;

  @override
  List<Object> get props => [domainName];
}

class UsernameChanged extends SignupEvent {
  const UsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class PasswordChanged extends SignupEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}
