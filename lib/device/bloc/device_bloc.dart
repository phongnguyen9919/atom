import 'package:atom/packages/models/device.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required Device device,
  }) : super(DeviceState(
          domain: domain,
          isAdmin: isAdmin,
          device: device,
        ));

  final UserRepository _userRepository;

  Stream<dynamic> get record => _userRepository.record(state.domain);
}
