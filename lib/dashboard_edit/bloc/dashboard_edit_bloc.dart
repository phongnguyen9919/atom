import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_edit_event.dart';
part 'dashboard_edit_state.dart';

class DashboardEditBloc extends Bloc<DashboardEditEvent, DashboardEditState> {
  DashboardEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required bool isEdit,
    required Dashboard? initialDashboard,
  }) : super(DashboardEditState(
            isAdmin: isAdmin,
            domain: domain,
            isEdit: isEdit,
            initialDashboard: initialDashboard)) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<DashboardEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<DashboardEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<DashboardEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DashboardEditStatus.waiting));
      await _userRepository.saveDashboard(
        domain: state.domain,
        id: state.initialDashboard?.id,
        name: state.name,
      );
      emit(state.copyWith(status: DashboardEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(
          status: DashboardEditStatus.failure, error: () => err));
    }
  }
}
