part of 'alert_edit_bloc.dart';

abstract class AlertEditEvent extends Equatable {
  const AlertEditEvent();

  @override
  List<Object> get props => [];
}

class GetDevices extends AlertEditEvent {
  const GetDevices();
}

class Submitted extends AlertEditEvent {
  const Submitted();
}

class NameChanged extends AlertEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class DeviceIdChanged extends AlertEditEvent {
  const DeviceIdChanged(this.deviceId);

  final String deviceId;

  @override
  List<Object> get props => [deviceId];
}

class RelateChanged extends AlertEditEvent {
  const RelateChanged(this.relate);

  final bool relate;

  @override
  List<Object> get props => [relate];
}

class LvalueChanged extends AlertEditEvent {
  const LvalueChanged(this.lvalue);

  final String lvalue;

  @override
  List<Object> get props => [lvalue];
}

class RvalueChanged extends AlertEditEvent {
  const RvalueChanged(this.rvalue);

  final String rvalue;

  @override
  List<Object> get props => [rvalue];
}

class IsEditChanged extends AlertEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
