import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alert_edit_event.dart';
part 'alert_edit_state.dart';

class AlertEditBloc extends Bloc<AlertEditEvent, AlertEditState> {
  AlertEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required bool isEdit,
    required Alert? initialAlert,
  }) : super(AlertEditState(
          isAdmin: isAdmin,
          domain: domain,
          isEdit: isEdit,
          name: initialAlert?.name ?? '',
          deviceId: initialAlert?.deviceID ?? '',
          relate: initialAlert?.relate ?? true,
          lvalue: initialAlert?.lvalue ?? '',
          rvalue: initialAlert?.rvalue ?? '',
          initialAlert: initialAlert,
        )) {
    on<GetDevices>(_onGetDevices);
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DeviceIdChanged>(_onDeviceIdChanged);
    on<RelateChanged>(_onRelateChanged);
    on<LvalueChanged>(_onLvalueChanged);
    on<RvalueChanged>(_onRvalueChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  Future<void> _onGetDevices(
      GetDevices event, Emitter<AlertEditState> emit) async {
    try {
      final json = await _userRepository.getDevices(state.domain);
      final devices =
          json.map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
      emit(state.copyWith(devices: devices));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: AlertEditStatus.failure, error: () => err));
    }
  }

  void _onIsEditChanged(IsEditChanged event, Emitter<AlertEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<AlertEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDeviceIdChanged(DeviceIdChanged event, Emitter<AlertEditState> emit) {
    emit(state.copyWith(deviceId: event.deviceId));
  }

  void _onRelateChanged(RelateChanged event, Emitter<AlertEditState> emit) {
    emit(state.copyWith(relate: event.relate));
  }

  void _onLvalueChanged(LvalueChanged event, Emitter<AlertEditState> emit) {
    emit(state.copyWith(lvalue: event.lvalue));
  }

  void _onRvalueChanged(RvalueChanged event, Emitter<AlertEditState> emit) {
    emit(state.copyWith(rvalue: event.rvalue));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<AlertEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AlertEditStatus.waiting));
      await _userRepository.saveAlert(
        domain: state.domain,
        id: state.initialAlert?.id,
        name: state.name,
        deviceId: state.deviceId,
        relate: state.relate,
        lvalue: state.lvalue,
        rvalue: state.rvalue,
      );
      emit(state.copyWith(status: AlertEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: AlertEditStatus.failure, error: () => err));
    }
  }
}
