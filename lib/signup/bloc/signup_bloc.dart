import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(this._userRepository) : super(const SignupState()) {
    on<Submitted>(_onSignup);
    on<DomainNameChanged>(_onDomainNameChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordChanged>(_onPasswordChanged);
  }

  final UserRepository _userRepository;

  void _onDomainNameChanged(
    DomainNameChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(domainName: event.domainName));
  }

  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSignup(
    Submitted event,
    Emitter<SignupState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SignupStatus.waiting));
      await _userRepository.signup(
          domain: state.domainName,
          username: state.username,
          password: state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: SignupStatus.failure, error: () => err));
    }
  }
}
