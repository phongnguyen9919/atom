import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc(this._userRepository,
      {required String domain, required bool isAdmin})
      : super(AlertState(domain: domain, isAdmin: isAdmin)) {
    on<DeleteAlert>(_onDeleteAlert);
  }

  final UserRepository _userRepository;

  Stream<dynamic> get alert => _userRepository.alert(state.domain);

  Future<void> _onDeleteAlert(
      DeleteAlert event, Emitter<AlertState> emit) async {
    await _userRepository.deleteAlert(domain: state.domain, id: event.alertId);
  }
}
