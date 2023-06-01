import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_edit_event.dart';
part 'group_edit_state.dart';

class GroupEditBloc extends Bloc<GroupEditEvent, GroupEditState> {
  GroupEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required bool isEdit,
    required String? parentId,
    required String? initialId,
  }) : super(GroupEditState(
            isAdmin: isAdmin,
            domain: domain,
            parentId: parentId,
            isEdit: isEdit,
            initialId: initialId)) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<GroupEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<GroupEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<GroupEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: GroupEditStatus.waiting));
      await _userRepository.saveGroup(
        domain: state.domain,
        parentId: state.parentId,
        id: state.initialId,
        name: state.name,
      );
      emit(state.copyWith(status: GroupEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: GroupEditStatus.failure, error: () => err));
    }
  }
}
