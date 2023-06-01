part of 'device_bloc.dart';

class DeviceState extends Equatable {
  const DeviceState({
    this.domain = '',
    this.isAdmin = false,
    required this.device,
  });

  final String domain;
  final bool isAdmin;
  final Device device;

  @override
  List<Object> get props => [domain, isAdmin, device];

  DeviceState copyWith({
    String? domain,
    bool? isAdmin,
    Device? device,
  }) {
    return DeviceState(
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
      device: device ?? this.device,
    );
  }
}
