import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'broker_edit_event.dart';
part 'broker_edit_state.dart';

class BrokerEditBloc extends Bloc<BrokerEditEvent, BrokerEditState> {
  BrokerEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required bool isEdit,
    required Broker? initialBroker,
  }) : super(BrokerEditState(
          isAdmin: isAdmin,
          domain: domain,
          isEdit: isEdit,
          name: initialBroker?.name ?? '',
          url: initialBroker?.url ?? '',
          port: initialBroker != null ? initialBroker.port.toString() : '',
          account: initialBroker?.account,
          password: initialBroker?.password,
          initialBroker: initialBroker,
        )) {
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<UrlChanged>(_onUrlChanged);
    on<PortChanged>(_onPortChanged);
    on<AccountChanged>(_onAccountChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<BrokerEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<BrokerEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onUrlChanged(UrlChanged event, Emitter<BrokerEditState> emit) {
    emit(state.copyWith(url: event.url));
  }

  void _onPortChanged(PortChanged event, Emitter<BrokerEditState> emit) {
    emit(state.copyWith(port: event.port));
  }

  void _onAccountChanged(AccountChanged event, Emitter<BrokerEditState> emit) {
    emit(state.copyWith(account: event.account));
  }

  void _onPasswordChanged(
      PasswordChanged event, Emitter<BrokerEditState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<BrokerEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BrokerEditStatus.waiting));
      await _userRepository.saveBroker(
        domain: state.domain,
        id: state.initialBroker?.id,
        name: state.name,
        url: state.url.trim(),
        port: int.parse(state.port),
        account: state.account,
        password: state.password,
      );
      emit(state.copyWith(status: BrokerEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: BrokerEditStatus.failure, error: () => err));
    }
  }
}
