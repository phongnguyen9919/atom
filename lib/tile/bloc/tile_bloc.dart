import 'dart:async';
import 'dart:convert';

import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/mqtt_client/gateway_client.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rfc_6901/rfc_6901.dart';

part 'tile_event.dart';
part 'tile_state.dart';

class TileBloc extends Bloc<TileEvent, TileState> {
  TileBloc(this._userRepository,
      {required String domain, required bool isAdmin})
      : super(TileState(domain: domain, isAdmin: isAdmin)) {
    on<Started>(_onStarted);
    on<GatewayStatusSubscriptionRequested>(
      _onGatewayStatusSubscribed,
      transformer: concurrent(),
    );
    on<GatewayStatusCloseSubscriptionRequested>(
      _onGatewayStatusCloseSubscribed,
      transformer: concurrent(),
    );
    on<BrokerConnectionRequested>(
      _onBrokerConnected,
      transformer: concurrent(),
    );
    on<GatewayListenRequested>(
      _onGatewayListened,
      transformer: concurrent(),
    );
    on<GatewayPublishRequested>(
      _onGatewayPublished,
      transformer: concurrent(),
    );
    on<DashboardChanged>(_onDashboardChanged);
    on<TileChanged>(_onTileChanged);
    on<BrokerChanged>(_onBrokerChanged);
    on<DeviceChanged>(_onDeviceChanged);
    on<AlertChanged>(_onAlertChanged);
    on<AlertRecordChanged>(_onAlertRecordChanged);
    on<IsReadChanged>(_onIsReadChanged);
    on<DashboardIdChanged>(_onDashboardIdChanged);
    on<GatewayClientViewChanged>(_onGatewayClientViewChanged);
    on<BrokerTopicPayloadsChanged>(_onBrokerTopicPayloadsChanged);
    on<TileValueViewChanged>(_onTileValueViewChanged);
    on<DeleteDashboard>(_onDeleteDashboard);
    on<DeleteTile>(_onDeleteTile);
  }

  final UserRepository _userRepository;
  StreamSubscription<dynamic>? _dashboardSubsription;
  StreamSubscription<dynamic>? _tileSubsription;
  StreamSubscription<dynamic>? _deviceSubsription;
  StreamSubscription<dynamic>? _brokerSubsription;
  StreamSubscription<dynamic>? _alertSubsription;
  StreamSubscription<dynamic>? _alertRecordSubsription;

  Future<void> _onDeleteDashboard(
      DeleteDashboard event, Emitter<TileState> emit) async {
    await _userRepository.deleteDashboard(
        domain: state.domain, id: event.dashboardId);
    if (state.dashboards.isNotEmpty) {
      add(DashboardIdChanged(dashboardId: state.dashboards.first.id));
    }
  }

  Future<void> _onDeleteTile(DeleteTile event, Emitter<TileState> emit) async {
    await _userRepository.deleteTile(domain: state.domain, id: event.tileId);
  }

  void handleBrokerChange(List<Broker> brokers, TileState state) {
    final brokerView = {for (final br in brokers) br.id: br};

    final gatewayClientView =
        Map<FieldId, GatewayClient>.from(state.gatewayClientView);
    final brokerTopicPayloads =
        Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);

    // hanlde new broker
    final newBrokers = brokers.where(
      (br) => !state.brokerView.keys.contains(br.id),
    );
    for (final br in newBrokers) {
      // create new gateway client
      final gatewayClient = _userRepository.createClient(
        brokerID: br.id,
        url: br.url,
        port: br.port,
        account: br.account,
        password: br.password,
      );
      gatewayClientView[br.id] = gatewayClient;
      brokerTopicPayloads[br.id] = <String, String?>{};
      add(GatewayStatusSubscriptionRequested(gatewayClient));
      add(BrokerConnectionRequested(gatewayClient));
    }
    // handle edited brokers
    final editedBrokers = brokers.where(
      (br) =>
          state.brokerView.keys.contains(br.id) &&
          state.brokerView[br.id] != brokerView[br.id],
    );
    for (final br in editedBrokers) {
      // only restart gateway client when either
      // url, port, account, password has changed
      if (state.brokerView[br.id]!.url != brokerView[br.id]!.url ||
          state.brokerView[br.id]!.port != brokerView[br.id]!.port ||
          state.brokerView[br.id]!.account != brokerView[br.id]!.account ||
          state.brokerView[br.id]!.password != brokerView[br.id]!.password) {
        // disconnect old gwCl
        final oldGatewayClient = gatewayClientView[br.id];
        if (oldGatewayClient != null) {
          oldGatewayClient.disconnect();
        }
        // create new gateway client
        final gatewayClient = _userRepository.createClient(
          brokerID: br.id,
          url: br.url,
          port: br.port,
          account: br.account,
          password: br.password,
        );
        gatewayClientView[br.id] = gatewayClient;
        add(GatewayStatusSubscriptionRequested(gatewayClient));
        add(BrokerConnectionRequested(gatewayClient));
      }
    }
    // handle deleted brokers
    final deletedBrokers =
        state.brokers.where((br) => !brokerView.keys.contains(br.id));
    for (final br in deletedBrokers) {
      // close its status stream
      final gatewayClient = gatewayClientView[br.id];
      if (gatewayClient != null) {
        add(GatewayStatusCloseSubscriptionRequested(gatewayClient));
        // remove it from brTpPl
        brokerTopicPayloads.remove(br.id);
        // disconnect old gwCl
        gatewayClient.disconnect();
      }
      // remove it from gwClView
      gatewayClientView.remove(br.id);
    }
    add(BrokerChanged(brokers: brokers));
    add(GatewayClientViewChanged(gatewayClientView: gatewayClientView));
    add(BrokerTopicPayloadsChanged(brokerTopicPayloads: brokerTopicPayloads));
  }

  void handleDevice(List<Device> devices, TileState state) {
    final deviceView = {for (final dv in devices) dv.id: dv};
    // clone
    final brokerTopicPayloads =
        Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
    // handle new device
    final newDevices = devices.where(
      (dv) => !state.deviceView.keys.contains(dv.id),
    );
    for (final dv in newDevices) {
      if (brokerTopicPayloads.containsKey(dv.brokerID)) {
        final brokerTopic = brokerTopicPayloads[dv.brokerID]!;
        if (!brokerTopic.containsKey(dv.topic)) {
          brokerTopic[dv.topic] = null;
          final brokerStatus = state.brokerStatusView[dv.brokerID];
          final gatewayClient = state.gatewayClientView[dv.brokerID];
          if (gatewayClient != null &&
              brokerStatus != null &&
              brokerStatus.isConnected) {
            gatewayClient.subscribe(topic: dv.topic, qos: dv.qos);
          }
          brokerTopicPayloads[dv.brokerID] = brokerTopic;
        }
      }
    }
    // handle edited devices
    final editedDevices = devices.where(
      (dv) =>
          state.deviceView.keys.contains(dv.id) &&
          state.deviceView[dv.id] != deviceView[dv.id],
    );
    for (final dv in editedDevices) {
      final oldDevice = state.deviceView[dv.id]!;
      // only handle when device changed broker or topic

      if (oldDevice.brokerID != dv.brokerID || oldDevice.topic != dv.topic) {
        // delete old topic from old brokerTopic
        if (brokerTopicPayloads.containsKey(oldDevice.brokerID)) {
          final oldBrokerTopic = brokerTopicPayloads[oldDevice.brokerID]!;
          if (oldBrokerTopic.containsKey(oldDevice.topic)) {
            oldBrokerTopic.remove(oldDevice.topic);
            final brokerStatus = state.brokerStatusView[oldDevice.brokerID];
            final oldGatewayClient =
                state.gatewayClientView[oldDevice.brokerID];
            if (oldGatewayClient != null &&
                brokerStatus != null &&
                brokerStatus.isConnected) {
              // unsubscribe old topic
              oldGatewayClient.unsubscribe(oldDevice.topic);
            }
            brokerTopicPayloads[oldDevice.brokerID] = oldBrokerTopic;
          }
        }
        // add new topic to brokerTopic
        if (brokerTopicPayloads.containsKey(oldDevice.brokerID)) {
          final newBrokerTopic = brokerTopicPayloads[dv.brokerID]!;
          if (!newBrokerTopic.containsKey(dv.topic)) {
            newBrokerTopic[dv.topic] = null;
            final brokerStatus = state.brokerStatusView[dv.brokerID];
            final gatewayClient = state.gatewayClientView[dv.brokerID];
            if (gatewayClient != null &&
                brokerStatus != null &&
                brokerStatus.isConnected) {
              gatewayClient.subscribe(topic: dv.topic, qos: dv.qos);
            }
            brokerTopicPayloads[dv.brokerID] = newBrokerTopic;
          }
        }
      }
    }
    // handle deleted devices
    final deleteDevices =
        state.devices.where((dv) => !deviceView.keys.contains(dv.id));
    for (final dv in deleteDevices) {
      if (brokerTopicPayloads.containsKey(dv.brokerID)) {
        final brokerTopic = brokerTopicPayloads[dv.brokerID]!;
        if (brokerTopic.containsKey(dv.topic)) {
          brokerTopic.remove(dv.topic);
          final brokerStatus = state.brokerStatusView[dv.brokerID];
          final gatewayClient = state.gatewayClientView[dv.brokerID];
          if (gatewayClient != null &&
              brokerStatus != null &&
              brokerStatus.isConnected) {
            // unsubscribe old topic
            gatewayClient.unsubscribe(dv.topic);
          }
          brokerTopicPayloads[dv.brokerID] = brokerTopic;
        }
      }
    }

    add(DeviceChanged(devices: devices));
    add(BrokerTopicPayloadsChanged(brokerTopicPayloads: brokerTopicPayloads));
  }

  void handleTileChange(List<Tile> tiles, TileState state) {
    final tileView = {for (final tl in tiles) tl.id: tl};
    // clone
    final tileValueView = Map<FieldId, String?>.from(state.tileValueView);
    // handle new tile and edited tile
    final newTiles = tiles.where(
      (tl) => !state.tileView.keys.contains(tl.id),
    );
    final editedTiles = tiles.where(
      (dv) =>
          state.deviceView.keys.contains(dv.id) &&
          state.deviceView[dv.id] != tileView[dv.id],
    );
    for (final tl in [...newTiles, ...editedTiles]) {
      final dv = state.deviceView[tl.deviceId];
      final brokerTopic = state.brokerTopicPayloads[dv?.brokerID];
      if (brokerTopic != null &&
          brokerTopic.containsKey(dv?.topic) &&
          dv != null) {
        final payload = brokerTopic[dv.topic];
        if (payload == null) {
          tileValueView[tl.id] = null;
        } else {
          if (dv.jsonPath != '') {
            final value = readJson(
              expression: dv.jsonPath,
              payload: payload,
            );
            tileValueView[tl.id] = value;
          } else {
            tileValueView[tl.id] = payload;
          }
        }
      }
    }
    // handle deleted tiles
    final deletedTiles =
        state.tiles.where((tl) => !tileView.keys.contains(tl.id));
    for (final tl in deletedTiles) {
      tileValueView.remove(tl.id);
    }

    add(TileChanged(tile: tiles));
    add(TileValueViewChanged(tileValueView: tileValueView));
  }

  void _onStarted(Started event, Emitter<TileState> emit) {
    _brokerSubsription = _userRepository.broker(state.domain).listen((data) {
      final brokers = (data as List<dynamic>)
          .map((e) => Broker.fromJson(e as Map<String, dynamic>))
          .toList();
      handleBrokerChange(brokers, state);
    });

    _deviceSubsription = _userRepository.device(state.domain).listen((data) {
      final devices = (data as List<dynamic>)
          .map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList();
      handleDevice(devices, state);
    });

    _dashboardSubsription =
        _userRepository.dashboard(state.domain).listen((data) {
      final dashboards = (data as List<dynamic>)
          .map((e) => Dashboard.fromJson(e as Map<String, dynamic>))
          .toList();
      if (state.selectedDashboardId == '' && dashboards.isNotEmpty) {
        add(DashboardChanged(dashboard: dashboards));
        add(DashboardIdChanged(dashboardId: dashboards.first.id));
      } else {
        add(DashboardChanged(dashboard: dashboards));
      }
    });

    _tileSubsription = _userRepository.tile(state.domain).listen((data) {
      final tiles = (data as List<dynamic>)
          .map((e) => Tile.fromJson(e as Map<String, dynamic>))
          .toList();
      handleTileChange(tiles, state);
    });

    _alertSubsription = _userRepository.alert(state.domain).listen((data) {
      final alerts = (data as List<dynamic>)
          .map((e) => Alert.fromJson(e as Map<String, dynamic>))
          .toList();
      add(AlertChanged(alerts: alerts));
    });

    _alertRecordSubsription =
        _userRepository.alertRecord(state.domain).listen((data) {
      final alertRecords = (data as List<dynamic>)
          .map((e) => AlertRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      add(AlertRecordChanged(alertRecords: alertRecords));
      if (state.alertRecords.isNotEmpty) {
        add(const IsReadChanged(isRead: false));
      }
    });

    emit(state.copyWith(status: TileStatus.normal));

    // clone and update gatewayClients
    final gatewayClientView =
        Map<FieldId, GatewayClient>.from(state.gatewayClientView);
    for (final broker in state.brokers) {
      // create new gateway client
      final gatewayClient = _userRepository.createClient(
        brokerID: broker.id,
        url: broker.url,
        port: broker.port,
        account: broker.account,
        password: broker.password,
      );
      gatewayClientView[broker.id] = gatewayClient;
      add(GatewayStatusSubscriptionRequested(gatewayClient));
      add(BrokerConnectionRequested(gatewayClient));
    }
    emit(state.copyWith(gatewayClientView: gatewayClientView));
  }

  Future<void> _onGatewayStatusSubscribed(
    GatewayStatusSubscriptionRequested event,
    Emitter<TileState> emit,
  ) async {
    await emit.forEach<ConnectionStatus>(
      _userRepository.getConnectionStatus(event.gatewayClient),
      onData: (status) {
        final brokerStatusView =
            Map<FieldId, ConnectionStatus>.from(state.brokerStatusView);
        brokerStatusView[event.gatewayClient.brokerID] = status;
        if (status.isDisconnected) {
          final gwClExist =
              state.gatewayClientView.containsKey(event.gatewayClient.brokerID);
          final brTopicExist = state.brokerTopicPayloads
              .containsKey(event.gatewayClient.brokerID);
          final brStExist =
              state.brokerStatusView.containsKey(event.gatewayClient.brokerID);
          // if it disconnected because mqtt broker error
          if (gwClExist && brTopicExist && brStExist) {
            add(BrokerConnectionRequested(event.gatewayClient));
          }
        }
        return state.copyWith(brokerStatusView: brokerStatusView);
      },
    );
  }

  Future<void> _onGatewayStatusCloseSubscribed(
    GatewayStatusCloseSubscriptionRequested event,
    Emitter<TileState> emit,
  ) async {
    await _userRepository.closeConnectionStatusStream(event.gatewayClient);
    final brokerStatusView =
        Map<FieldId, ConnectionStatus>.from(state.brokerStatusView)
          ..remove(event.gatewayClient.brokerID);
    emit(state.copyWith(brokerStatusView: brokerStatusView));
  }

  Future<void> _onBrokerConnected(
    BrokerConnectionRequested event,
    Emitter<TileState> emit,
  ) async {
    try {
      await event.gatewayClient.connect();
      // clone and update brokerTopicPayloads
      final brokerTopicPayloads =
          Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
      final brokerTopic = brokerTopicPayloads[event.gatewayClient.brokerID] ??
          <String, String?>{};
      for (final dv in state.devices) {
        if (dv.brokerID == event.gatewayClient.brokerID) {
          event.gatewayClient.subscribe(topic: dv.topic, qos: dv.qos);
          brokerTopic[dv.topic] = null;
        }
      }
      brokerTopicPayloads[event.gatewayClient.brokerID] = brokerTopic;
      add(GatewayListenRequested(event.gatewayClient));
      emit(state.copyWith(brokerTopicPayloads: brokerTopicPayloads));
    } catch (e) {
      Future.delayed(
        const Duration(seconds: 6),
        () => add(BrokerConnectionRequested(event.gatewayClient)),
      );
    }
  }

  Future<void> _onGatewayListened(
    GatewayListenRequested event,
    Emitter<TileState> emit,
  ) async {
    await emit.forEach<Map<String, String>>(
      event.gatewayClient.getPublishMessage(),
      onData: (message) {
        final brokerID = message['broker_id']!;
        final topic = message['topic']!;
        final payload = message['payload']!;
        // clone
        final tileValueView = Map<FieldId, String?>.from(state.tileValueView);
        final brokerTopicPayloads =
            Map<FieldId, Map<String, String?>>.from(state.brokerTopicPayloads);
        final brokerTopic = brokerTopicPayloads[event.gatewayClient.brokerID] ??
            <String, String?>{};
        // update brokerTopicPayloads
        brokerTopic[topic] = payload;
        brokerTopicPayloads[brokerID] = brokerTopic;

        // scan tile
        for (final tile in state.tiles) {
          final dv = state.deviceView[tile.deviceId]!;
          // update tile value view if device's broker and topic match
          // with payload's broker and topic
          if (dv.brokerID == brokerID && dv.topic == topic) {
            if (dv.jsonPath != '') {
              final value = readJson(
                expression: dv.jsonPath,
                payload: payload,
              );
              if (value == '?') {
                if (tileValueView[tile.id] == null) {
                  tileValueView[tile.id] = value;
                }
              } else {
                tileValueView[tile.id] = value;
              }
            } else {
              tileValueView[tile.id] = payload;
            }
          }
        }

        // scan alert
        // for (final alert in state.alerts) {
        //   final dv = state.deviceView[alert.deviceID]!;
        //   // update tile value view if device's broker and topic match
        //   // with payload's broker and topic
        //   if (dv.brokerID == brokerID && dv.topic == topic) {
        //     bool? lcompare;
        //     bool? rcompare;
        //     late String activeValue = payload;
        //     if (dv.jsonPath != '') {
        //       final value = readJson(
        //         expression: dv.jsonPath,
        //         payload: payload,
        //       );
        //       if (value != '?' && double.tryParse(value) != null) {
        //         activeValue = value;
        //         lcompare = double.parse(value) < double.parse(alert.lvalue);
        //         rcompare = double.parse(value) > double.parse(alert.rvalue);
        //       }
        //     } else {
        //       lcompare = double.parse(payload) < double.parse(alert.lvalue);
        //       rcompare = double.parse(payload) > double.parse(alert.rvalue);
        //     }
        //     if (lcompare != null && rcompare != null) {
        //       // AND
        //       if (alert.relate && lcompare && rcompare) {
        //         _userRepository.saveAlertRecord(
        //           domain: state.domain,
        //           alertId: alert.id,
        //           time: DateTime.now(),
        //           value: activeValue,
        //         );
        //       }
        //       // OR
        //       else if (!alert.relate && (lcompare || rcompare)) {
        //         _userRepository.saveAlertRecord(
        //           domain: state.domain,
        //           alertId: alert.id,
        //           time: DateTime.now(),
        //           value: activeValue,
        //         );
        //       }
        //     }
        //   }
        // }

        // scan device
        // for (final dv in state.devices) {
        //   if (dv.brokerID == brokerID && dv.topic == topic) {
        //     if (dv.jsonPath != '') {
        //       final value = readJson(
        //         expression: dv.jsonPath,
        //         payload: payload,
        //       );
        //       if (value == '?') {
        //         _userRepository.saveRecord(
        //           domain: state.domain,
        //           deviceId: dv.id,
        //           time: DateTime.now(),
        //           value: payload,
        //         );
        //       } else {
        //         _userRepository.saveRecord(
        //           domain: state.domain,
        //           deviceId: dv.id,
        //           time: DateTime.now(),
        //           value: value,
        //         );
        //       }
        //     } else {
        //       _userRepository.saveRecord(
        //         domain: state.domain,
        //         deviceId: dv.id,
        //         time: DateTime.now(),
        //         value: payload,
        //       );
        //     }
        //   }
        // }

        return state.copyWith(
          brokerTopicPayloads: brokerTopicPayloads,
          tileValueView: tileValueView,
        );
      },
    );
  }

  void _onGatewayPublished(
    GatewayPublishRequested event,
    Emitter<TileState> emit,
  ) {
    final activeDevice = state.deviceView[event.deviceID];
    final expression = activeDevice?.jsonPath;
    final topic = activeDevice?.topic;
    final qos = activeDevice?.qos;
    final brokerID = activeDevice?.brokerID;
    if (expression != null &&
        topic != null &&
        qos != null &&
        brokerID != null) {
      final client = state.gatewayClientView[brokerID];
      final connectionStatus = state.brokerStatusView[brokerID];
      if (client != null &&
          connectionStatus != null &&
          connectionStatus.isConnected) {
        final payload = writeJson(expression: expression, value: event.value);
        _userRepository.publishMessage(
          client,
          topic: topic,
          payload: payload,
          qos: qos,
        );
      }
    }
  }

  void _onDashboardIdChanged(
      DashboardIdChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(selectedDashboardId: event.dashboardId));
  }

  void _onDashboardChanged(DashboardChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(dashboards: event.dashboard));
  }

  void _onTileChanged(TileChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(tiles: event.tile));
  }

  void _onBrokerChanged(BrokerChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(brokers: event.brokers));
  }

  void _onDeviceChanged(DeviceChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(devices: event.devices));
  }

  void _onGatewayClientViewChanged(
      GatewayClientViewChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(gatewayClientView: event.gatewayClientView));
  }

  void _onBrokerTopicPayloadsChanged(
      BrokerTopicPayloadsChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(brokerTopicPayloads: event.brokerTopicPayloads));
  }

  void _onTileValueViewChanged(
      TileValueViewChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(tileValueView: event.tileValueView));
  }

  void _onAlertChanged(AlertChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(alerts: event.alerts));
  }

  void _onAlertRecordChanged(
      AlertRecordChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(alertRecords: event.alertRecords));
  }

  void _onIsReadChanged(IsReadChanged event, Emitter<TileState> emit) {
    emit(state.copyWith(isReadRecord: event.isRead));
  }

  /// get value in json by expression
  String readJson({required String expression, required String payload}) {
    try {
      final decoded = jsonDecode(payload);
      final pointer = JsonPointer(expression);
      final value = pointer.read(decoded);
      if (value == null) {
        return '?';
      }
      switch (value.runtimeType) {
        case String:
          return value as String;
        default:
          return value.toString();
      }
    } catch (e) {
      return '?';
    }
  }

  /// write value to json by expression
  String writeJson({required String expression, required String value}) {
    try {
      if (expression == '') {
        return value;
      } else {
        final pointer = JsonPointer(expression);
        final payload = pointer.write({}, value);
        return jsonEncode(payload);
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> close() {
    _dashboardSubsription?.cancel();
    _tileSubsription?.cancel();
    _brokerSubsription?.cancel();
    _deviceSubsription?.cancel();
    _alertSubsription?.cancel();
    _alertRecordSubsription?.cancel();
    return super.close();
  }
}
