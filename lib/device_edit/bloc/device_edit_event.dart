part of 'device_edit_bloc.dart';

abstract class DeviceEditEvent extends Equatable {
  const DeviceEditEvent();

  @override
  List<Object> get props => [];
}

class GetBrokers extends DeviceEditEvent {
  const GetBrokers();
}

class Submitted extends DeviceEditEvent {
  const Submitted();
}

class NameChanged extends DeviceEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class TopicChanged extends DeviceEditEvent {
  const TopicChanged(this.topic);

  final String topic;

  @override
  List<Object> get props => [topic];
}

class QosChanged extends DeviceEditEvent {
  const QosChanged(this.qos);

  final int qos;

  @override
  List<Object> get props => [qos];
}

class BrokerIdChanged extends DeviceEditEvent {
  const BrokerIdChanged(this.brokerId);

  final String brokerId;

  @override
  List<Object> get props => [brokerId];
}

class JsonPathChanged extends DeviceEditEvent {
  const JsonPathChanged(this.jsonPath);

  final String jsonPath;

  @override
  List<Object> get props => [jsonPath];
}

class UnitChanged extends DeviceEditEvent {
  const UnitChanged(this.unit);

  final String unit;

  @override
  List<Object> get props => [unit];
}

class IsEditChanged extends DeviceEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
