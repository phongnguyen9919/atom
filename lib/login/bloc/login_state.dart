part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  waiting,
  success,
  failure,
}

extension LoginStatusX on LoginStatus {
  bool isWaiting() => this == LoginStatus.waiting;
  bool isSuccess() => this == LoginStatus.success;
  bool isFailure() => this == LoginStatus.failure;
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.domainName = '',
    this.username = '',
    this.password = '',
    this.error,
    this.isAdmin,
  });

  final LoginStatus status;
  final String domainName;
  final String username;
  final String password;
  final String? error;
  final bool? isAdmin;

  @override
  List<Object?> get props =>
      [domainName, username, password, status, error, isAdmin];

  LoginState copyWith({
    String? domainName,
    String? username,
    String? password,
    LoginStatus? status,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return LoginState(
      domainName: domainName ?? this.domainName,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      isAdmin: isAdmin ?? this.isAdmin,
      error: error != null ? error() : this.error,
    );
  }
}
