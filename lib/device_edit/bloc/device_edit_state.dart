part of 'device_edit_bloc.dart';

enum DeviceEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension DeviceEditStatusX on DeviceEditStatus {
  bool isWaiting() => this == DeviceEditStatus.waiting;
  bool isSuccess() => this == DeviceEditStatus.success;
  bool isFailure() => this == DeviceEditStatus.failure;
}

class DeviceEditState extends Equatable {
  const DeviceEditState({
    required this.isAdmin,
    required this.domain,
    required this.parentId,
    this.status = DeviceEditStatus.normal,
    required this.isEdit,
    this.brokers = const <Broker>[],
    this.name = '',
    this.brokerId = '',
    this.topic = '',
    this.qos = 0,
    this.jsonPath = '',
    this.unit,
    this.initialId,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;
  final String? parentId;
  final List<Broker> brokers;

  // initial
  final String? initialId;

  // input
  final String name;
  final String brokerId;
  final String topic;
  final int qos;
  final String jsonPath;
  final String? unit;

  // status
  final DeviceEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props => [
        isAdmin,
        domain,
        isEdit,
        initialId,
        brokers,
        name,
        brokerId,
        topic,
        qos,
        jsonPath,
        unit,
        status,
        error
      ];

  DeviceEditState copyWith({
    bool? isAdmin,
    String? domain,
    List<Broker>? brokers,
    String? parentId,
    String? name,
    String? brokerId,
    String? topic,
    int? qos,
    String? jsonPath,
    String? unit,
    bool? isEdit,
    DeviceEditStatus? status,
    String? initialId,
    String? Function()? error,
  }) {
    return DeviceEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      brokers: brokers ?? this.brokers,
      domain: domain ?? this.domain,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      brokerId: brokerId ?? this.brokerId,
      topic: topic ?? this.topic,
      qos: qos ?? this.qos,
      jsonPath: jsonPath ?? this.jsonPath,
      unit: unit ?? this.unit,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialId: initialId ?? this.initialId,
      error: error != null ? error() : this.error,
    );
  }
}
