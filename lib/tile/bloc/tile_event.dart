part of 'tile_bloc.dart';

abstract class TileEvent extends Equatable {
  const TileEvent();

  @override
  List<Object?> get props => [];
}

class Started extends TileEvent {
  const Started();

  @override
  List<Object> get props => [];
}

class BrokerConnectionRequested extends TileEvent {
  const BrokerConnectionRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayStatusSubscriptionRequested extends TileEvent {
  const GatewayStatusSubscriptionRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayStatusCloseSubscriptionRequested extends TileEvent {
  const GatewayStatusCloseSubscriptionRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayListenRequested extends TileEvent {
  const GatewayListenRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayPublishRequested extends TileEvent {
  const GatewayPublishRequested({
    required this.deviceID,
    required this.value,
  });

  final FieldId deviceID;
  final String value;

  @override
  List<Object?> get props => [deviceID, value];
}

class DashboardIdChanged extends TileEvent {
  const DashboardIdChanged({required this.dashboardId});

  final String dashboardId;

  @override
  List<Object> get props => [dashboardId];
}

class DashboardChanged extends TileEvent {
  const DashboardChanged({required this.dashboard});

  final List<Dashboard> dashboard;

  @override
  List<Object> get props => [dashboard];
}

class TileChanged extends TileEvent {
  const TileChanged({required this.tile});

  final List<Tile> tile;

  @override
  List<Object> get props => [tile];
}

class BrokerChanged extends TileEvent {
  const BrokerChanged({required this.brokers});

  final List<Broker> brokers;

  @override
  List<Object> get props => [brokers];
}

class DeviceChanged extends TileEvent {
  const DeviceChanged({required this.devices});

  final List<Device> devices;

  @override
  List<Object> get props => [devices];
}

class AlertChanged extends TileEvent {
  const AlertChanged({required this.alerts});

  final List<Alert> alerts;

  @override
  List<Object> get props => [alerts];
}

class AlertRecordChanged extends TileEvent {
  const AlertRecordChanged({required this.alertRecords});

  final List<AlertRecord> alertRecords;

  @override
  List<Object> get props => [alertRecords];
}

class IsReadChanged extends TileEvent {
  const IsReadChanged({required this.isRead});

  final bool isRead;

  @override
  List<Object> get props => [isRead];
}

class GatewayClientViewChanged extends TileEvent {
  const GatewayClientViewChanged({required this.gatewayClientView});

  final Map<FieldId, GatewayClient> gatewayClientView;

  @override
  List<Object> get props => [gatewayClientView];
}

class BrokerTopicPayloadsChanged extends TileEvent {
  const BrokerTopicPayloadsChanged({required this.brokerTopicPayloads});

  final Map<FieldId, Map<String, String?>> brokerTopicPayloads;

  @override
  List<Object> get props => [brokerTopicPayloads];
}

class TileValueViewChanged extends TileEvent {
  const TileValueViewChanged({required this.tileValueView});

  final Map<FieldId, String?> tileValueView;

  @override
  List<Object> get props => [tileValueView];
}

class DeleteDashboard extends TileEvent {
  const DeleteDashboard({required this.dashboardId});

  final String dashboardId;

  @override
  List<Object> get props => [dashboardId];
}

class DeleteTile extends TileEvent {
  const DeleteTile({required this.tileId});

  final String tileId;

  @override
  List<Object> get props => [tileId];
}
