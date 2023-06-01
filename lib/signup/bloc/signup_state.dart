part of 'signup_bloc.dart';

enum SignupStatus {
  initial,
  waiting,
  success,
  failure,
}

extension SignupStatusX on SignupStatus {
  bool isWaiting() => this == SignupStatus.waiting;
  bool isSuccess() => this == SignupStatus.success;
  bool isFailure() => this == SignupStatus.failure;
}

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.initial,
    this.domainName = '',
    this.username = '',
    this.password = '',
    this.error,
  });

  final SignupStatus status;
  final String domainName;
  final String username;
  final String password;
  final String? error;

  @override
  List<Object?> get props => [domainName, username, password, status, error];

  SignupState copyWith({
    String? domainName,
    String? username,
    String? password,
    SignupStatus? status,
    String? Function()? error,
  }) {
    return SignupState(
      domainName: domainName ?? this.domainName,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error != null ? error() : this.error,
    );
  }
}
