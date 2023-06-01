import 'dart:convert';

import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/models/tile_type.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tile_edit_event.dart';
part 'tile_edit_state.dart';

class TileEditBloc extends Bloc<TileEditEvent, TileEditState> {
  TileEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required String dashboardId,
    required TileType type,
    required bool isEdit,
    required Tile? initialTile,
  }) : super(TileEditState(
          isAdmin: isAdmin,
          domain: domain,
          dashboardId: dashboardId,
          type: type,
          isEdit: isEdit,
          name: initialTile?.name ?? '',
          deviceId: initialTile?.deviceId ?? '',
          lob: initialTile?.lob ?? type.initialLob,
          initialTile: initialTile,
        )) {
    on<GetDevices>(_onGetDevices);
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DeviceIdChanged>(_onDeviceIdChanged);
    on<LobChanged>(_onLobChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  Future<void> _onGetDevices(
      GetDevices event, Emitter<TileEditState> emit) async {
    try {
      final json = await _userRepository.getDevices(state.domain);
      final devices =
          json.map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
      emit(state.copyWith(devices: devices));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: TileEditStatus.failure, error: () => err));
    }
  }

  void _onIsEditChanged(IsEditChanged event, Emitter<TileEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<TileEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDeviceIdChanged(DeviceIdChanged event, Emitter<TileEditState> emit) {
    emit(state.copyWith(deviceId: event.deviceId));
  }

  void _onLobChanged(LobChanged event, Emitter<TileEditState> emit) {
    final decoded = jsonDecode(state.lob) as Map<String, dynamic>;
    for (final k in event.lob.keys) {
      decoded[k] = event.lob[k];
    }
    emit(state.copyWith(lob: jsonEncode(decoded)));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<TileEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TileEditStatus.waiting));
      await _userRepository.saveTile(
        domain: state.domain,
        id: state.initialTile?.id,
        dashboardId: state.dashboardId,
        type: state.type.value,
        name: state.name,
        deviceId: state.deviceId,
        lob: state.lob,
      );
      emit(state.copyWith(status: TileEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: TileEditStatus.failure, error: () => err));
    }
  }
}
