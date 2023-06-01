part of 'tile_edit_bloc.dart';

enum TileEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension TileEditStatusX on TileEditStatus {
  bool isWaiting() => this == TileEditStatus.waiting;
  bool isSuccess() => this == TileEditStatus.success;
  bool isFailure() => this == TileEditStatus.failure;
}

class TileEditState extends Equatable {
  const TileEditState({
    required this.isAdmin,
    required this.domain,
    required this.dashboardId,
    required this.type,
    this.devices = const <Device>[],
    this.status = TileEditStatus.normal,
    required this.isEdit,
    this.name = '',
    this.deviceId = '',
    this.lob = '',
    this.initialTile,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;
  final String dashboardId;
  final TileType type;
  final List<Device> devices;

  // initial
  final Tile? initialTile;

  // input
  final String name;
  final String deviceId;
  final String lob;

  // status
  final TileEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props => [
        isAdmin,
        domain,
        devices,
        dashboardId,
        type,
        isEdit,
        initialTile,
        name,
        deviceId,
        lob,
        status,
        error
      ];

  TileEditState copyWith({
    bool? isAdmin,
    String? domain,
    String? dashboardId,
    List<Device>? devices,
    TileType? type,
    String? name,
    String? deviceId,
    String? lob,
    bool? isEdit,
    TileEditStatus? status,
    Tile? initialTile,
    String? Function()? error,
  }) {
    return TileEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      domain: domain ?? this.domain,
      dashboardId: dashboardId ?? this.dashboardId,
      type: type ?? this.type,
      devices: devices ?? this.devices,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      lob: lob ?? this.lob,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialTile: initialTile ?? this.initialTile,
      error: error != null ? error() : this.error,
    );
  }
}
