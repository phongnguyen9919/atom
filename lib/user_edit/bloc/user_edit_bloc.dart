import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_edit_event.dart';
part 'user_edit_state.dart';

class UserEditBloc extends Bloc<UserEditEvent, UserEditState> {
  UserEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required bool isEdit,
    required User? initialUser,
  }) : super(UserEditState(
            isAdmin: isAdmin,
            domain: domain,
            isEdit: isEdit,
            username: initialUser?.username ?? '',
            password: initialUser?.password ?? '',
            initialUser: initialUser)) {
    on<Submitted>(_onSubmitted);
    on<UsernameChanged>(_onUsernameChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<UserEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<UserEditState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<UserEditState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<UserEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserEditStatus.waiting));
      await _userRepository.saveUser(
        domain: state.domain,
        id: state.initialUser?.id,
        username: state.username,
        password: state.password,
      );
      emit(state.copyWith(status: UserEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: UserEditStatus.failure, error: () => err));
    }
  }
}
