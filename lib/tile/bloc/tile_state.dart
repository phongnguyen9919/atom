part of 'tile_bloc.dart';

enum TileStatus {
  normal,
  waiting,
  success,
  failure,
}

extension TileStatusX on TileStatus {
  bool isWaiting() => this == TileStatus.waiting;
  bool isSuccess() => this == TileStatus.success;
  bool isFailure() => this == TileStatus.failure;
}

class TileState extends Equatable {
  TileState({
    this.domain = '',
    this.status = TileStatus.waiting,
    this.isAdmin = false,
    this.selectedDashboardId = '',
    this.gatewayClientView = const {},
    this.brokerTopicPayloads = const {},
    this.tileValueView = const {},
    this.brokerStatusView = const {},
    this.brokers = const [],
    this.dashboards = const [],
    this.tiles = const [],
    this.devices = const [],
    this.alerts = const [],
    this.alertRecords = const [],
    this.isReadRecord = true,
  });

  // immutable
  final String domain;
  final bool isAdmin;

  // mutable
  final List<Broker> brokers;
  final List<Device> devices;
  final List<Dashboard> dashboards;
  final List<Tile> tiles;
  final List<Alert> alerts;
  final List<AlertRecord> alertRecords;

  final bool isReadRecord;
  final TileStatus status;

  /// <BrokerID, GatewayClient>
  final Map<FieldId, ConnectionStatus> brokerStatusView;

  /// <BrokerID, GatewayClient>
  final Map<FieldId, GatewayClient> gatewayClientView;

  /// <BrokerID, <Topic, Payload>>
  final Map<FieldId, Map<String, String?>> brokerTopicPayloads;

  /// <TileID, value?>
  final Map<FieldId, String?> tileValueView;

  // choose
  final String selectedDashboardId;

  String get selectedDashboardName {
    final m = dashboards
        .where((element) => element.id == selectedDashboardId)
        .toList();
    if (m.isNotEmpty) {
      return m.first.name;
    }
    return '';
  }

  Dashboard? get selectedDashboard {
    final m = dashboards
        .where((element) => element.id == selectedDashboardId)
        .toList();
    if (m.isNotEmpty) {
      return m.first;
    }
    return null;
  }

  late final Map<FieldId, Broker> brokerView = {
    for (final br in brokers) br.id: br
  };

  late final Map<FieldId, Tile> tileView = {for (final tl in tiles) tl.id: tl};

  late final Map<FieldId, Device> deviceView = {
    for (final dv in devices) dv.id: dv
  };

  List<Tile> get showTile => tiles
      .where((element) => element.dashboardId == selectedDashboardId)
      .toList();

  @override
  List<Object?> get props => [
        domain,
        status,
        isAdmin,
        dashboards,
        tiles,
        brokers,
        devices,
        alerts,
        brokerStatusView,
        gatewayClientView,
        brokerTopicPayloads,
        tileValueView,
        selectedDashboardId,
        isReadRecord,
        alertRecords,
      ];

  TileState copyWith({
    TileStatus? status,
    String? domain,
    bool? isAdmin,
    List<Dashboard>? dashboards,
    List<Tile>? tiles,
    List<Broker>? brokers,
    List<Device>? devices,
    List<Alert>? alerts,
    List<AlertRecord>? alertRecords,
    Map<FieldId, GatewayClient>? gatewayClientView,
    Map<FieldId, Map<String, String?>>? brokerTopicPayloads,
    Map<FieldId, String?>? tileValueView,
    Map<FieldId, ConnectionStatus>? brokerStatusView,
    String? selectedDashboardId,
    bool? isReadRecord,
  }) {
    return TileState(
      status: status ?? this.status,
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
      dashboards: dashboards ?? this.dashboards,
      tiles: tiles ?? this.tiles,
      brokers: brokers ?? this.brokers,
      devices: devices ?? this.devices,
      alerts: alerts ?? this.alerts,
      alertRecords: alertRecords ?? this.alertRecords,
      gatewayClientView: gatewayClientView ?? this.gatewayClientView,
      brokerTopicPayloads: brokerTopicPayloads ?? this.brokerTopicPayloads,
      tileValueView: tileValueView ?? this.tileValueView,
      brokerStatusView: brokerStatusView ?? this.brokerStatusView,
      selectedDashboardId: selectedDashboardId ?? this.selectedDashboardId,
      isReadRecord: isReadRecord ?? this.isReadRecord,
    );
  }
}
