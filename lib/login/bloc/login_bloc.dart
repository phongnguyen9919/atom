import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository) : super(const LoginState()) {
    on<Submitted>(_onLogin);
    on<DomainNameChanged>(_onDomainNameChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordChanged>(_onPasswordChanged);
  }

  final UserRepository _userRepository;

  void _onDomainNameChanged(
    DomainNameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(domainName: event.domainName));
  }

  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLogin(
    Submitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginStatus.waiting));
      final res = await _userRepository.login(
          domain: state.domainName,
          username: state.username,
          password: state.password);
      final isAdmin = res['is_admin'] as bool;
      emit(
        state.copyWith(
          status: LoginStatus.success,
          isAdmin: isAdmin,
        ),
      );
      await OneSignal.shared.setExternalUserId(res['id']);
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: LoginStatus.failure, error: () => err));
    }
  }
}
