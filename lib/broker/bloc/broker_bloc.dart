import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'broker_event.dart';
part 'broker_state.dart';

class BrokerBloc extends Bloc<BrokerEvent, BrokerState> {
  BrokerBloc(this._userRepository,
      {required String domain, required bool isAdmin})
      : super(BrokerState(domain: domain, isAdmin: isAdmin)) {
    on<DeleteBroker>(_onDeleteBroker);
  }

  final UserRepository _userRepository;

  Stream<dynamic> get broker => _userRepository.broker(state.domain);

  Future<void> _onDeleteBroker(
      DeleteBroker event, Emitter<BrokerState> emit) async {
    await _userRepository.deleteBroker(
        domain: state.domain, id: event.brokerId);
  }
}
