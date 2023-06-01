part of 'tile_edit_bloc.dart';

abstract class TileEditEvent extends Equatable {
  const TileEditEvent();

  @override
  List<Object> get props => [];
}

class GetDevices extends TileEditEvent {
  const GetDevices();
}

class Submitted extends TileEditEvent {
  const Submitted();
}

class NameChanged extends TileEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class DeviceIdChanged extends TileEditEvent {
  const DeviceIdChanged(this.deviceId);

  final String deviceId;

  @override
  List<Object> get props => [deviceId];
}

class LobChanged extends TileEditEvent {
  const LobChanged(this.lob);

  final Map<String, dynamic> lob;

  @override
  List<Object> get props => [lob];
}

class IsEditChanged extends TileEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
