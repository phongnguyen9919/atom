part of 'alert_edit_bloc.dart';

enum AlertEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension AlertEditStatusX on AlertEditStatus {
  bool isWaiting() => this == AlertEditStatus.waiting;
  bool isSuccess() => this == AlertEditStatus.success;
  bool isFailure() => this == AlertEditStatus.failure;
}

class AlertEditState extends Equatable {
  const AlertEditState({
    required this.isAdmin,
    required this.domain,
    this.status = AlertEditStatus.normal,
    this.devices = const [],
    required this.isEdit,
    required this.name,
    required this.deviceId,
    required this.relate,
    required this.lvalue,
    required this.rvalue,
    this.initialAlert,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;
  final List<Device> devices;

  // initial
  final Alert? initialAlert;

  // input
  final String name;
  final String deviceId;
  final bool relate;
  final String lvalue;
  final String rvalue;

  // status
  final AlertEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props => [
        isAdmin,
        domain,
        isEdit,
        initialAlert,
        devices,
        name,
        deviceId,
        relate,
        lvalue,
        rvalue,
        status,
        error
      ];

  AlertEditState copyWith({
    bool? isAdmin,
    String? domain,
    List<Device>? devices,
    String? name,
    String? deviceId,
    bool? relate,
    String? lvalue,
    String? rvalue,
    bool? isEdit,
    AlertEditStatus? status,
    Alert? initialAlert,
    String? Function()? error,
  }) {
    return AlertEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      domain: domain ?? this.domain,
      devices: devices ?? this.devices,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      relate: relate ?? this.relate,
      lvalue: lvalue ?? this.lvalue,
      rvalue: rvalue ?? this.rvalue,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialAlert: initialAlert ?? this.initialAlert,
      error: error != null ? error() : this.error,
    );
  }
}
