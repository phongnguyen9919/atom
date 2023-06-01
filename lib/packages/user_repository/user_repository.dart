import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/mqtt_client/gateway_client.dart';
import 'package:atom/packages/supabase_client/supabase_client.dart';

class UserRepository {
  UserRepository({
    required DatabaseClient databaseClient,
  }) : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  // ================== GATEWAY ======================

  /// Creates [GatewayClient]
  GatewayClient createClient({
    required String brokerID,
    required String url,
    required int port,
    required String? account,
    required String? password,
  }) {
    return GatewayClient(
      brokerID: brokerID,
      url: url,
      port: port,
      account: account,
      password: password,
    );
  }

  /// Gets a [Stream] of published msg from given [GatewayClient]
  Stream<Map<String, String>> getPublishMessage(GatewayClient client) {
    return client.getPublishMessage();
  }

  /// Publish payload given [GatewayClient]
  void publishMessage(
    GatewayClient client, {
    required String payload,
    required String topic,
    required int qos,
    bool retain = true,
  }) {
    client.published(payload: payload, topic: topic, retain: retain, qos: qos);
  }

  /// Gets a [Stream] of [ConnectionStatus] from given [GatewayClient]
  Stream<ConnectionStatus> getConnectionStatus(GatewayClient client) {
    return client.getConnectionStatus();
  }

  /// Close connection status stream
  Future<void> closeConnectionStatusStream(GatewayClient client) async =>
      client.closeConnectionStatusStream();

  // ===================================

  Future<Map<String, dynamic>> login({
    required String domain,
    required String username,
    required String password,
  }) async =>
      _databaseClient.login(
          domain: domain, username: username, password: password);

  Future<void> signup({
    required String domain,
    required String username,
    required String password,
  }) async =>
      _databaseClient.signup(
          domain: domain, username: username, password: password);

  Stream<dynamic> member(String domain) => _databaseClient.member(domain);

  Future<void> saveUser({
    required String domain,
    required String username,
    required String password,
    String? id,
  }) async =>
      _databaseClient.saveUser(
          domain: domain, id: id, username: username, password: password);

  Future<void> deleteUser({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteUser(domain: domain, id: id);

  Stream<dynamic> broker(String domain) => _databaseClient.broker(domain);

  Future<List<dynamic>> getBrokers(String domain) =>
      _databaseClient.getBrokers(domain: domain);

  Future<void> saveBroker({
    required String domain,
    required String name,
    required String url,
    required int port,
    required String? account,
    required String? password,
    String? id,
  }) async =>
      _databaseClient.saveBroker(
        domain: domain,
        name: name,
        url: url,
        port: port,
        account: account,
        password: password,
        id: id,
      );

  Future<void> deleteBroker({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteBroker(domain: domain, id: id);

  Stream<dynamic> group(String domain) => _databaseClient.group(domain);

  Future<void> saveGroup({
    required String domain,
    required String name,
    required String? parentId,
    required String? id,
  }) async =>
      _databaseClient.saveGroup(
          domain: domain, name: name, parentId: parentId, id: id);

  Future<void> deleteGroup({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteGroup(domain: domain, id: id);

  Stream<dynamic> device(String domain) => _databaseClient.device(domain);

  Future<List<dynamic>> getDevices(String domain) =>
      _databaseClient.getDevices(domain: domain);

  Future<void> saveDevice({
    required String domain,
    required String name,
    required String brokerId,
    required String? groupId,
    required String topic,
    required int qos,
    required String jsonPath,
    required String? unit,
    String? id,
  }) async =>
      _databaseClient.saveDevice(
        domain: domain,
        name: name,
        brokerId: brokerId,
        groupId: groupId,
        topic: topic,
        qos: qos,
        jsonPath: jsonPath,
        unit: unit,
        id: id,
      );

  Future<void> deleteDevice({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteDevice(domain: domain, id: id);

  Stream<dynamic> dashboard(String domain) => _databaseClient.dashboard(domain);

  Future<void> saveDashboard({
    required String domain,
    required String name,
    String? id,
  }) async =>
      _databaseClient.saveDashboard(domain: domain, name: name, id: id);

  Future<void> deleteDashboard({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteDashboard(domain: domain, id: id);

  Stream<dynamic> tile(String domain) => _databaseClient.tile(domain);

  Future<void> saveTile({
    required String domain,
    required String name,
    required String dashboardId,
    required String deviceId,
    required String type,
    required String lob,
    String? id,
  }) async =>
      _databaseClient.saveTile(
        domain: domain,
        name: name,
        dashboardId: dashboardId,
        deviceId: deviceId,
        type: type,
        lob: lob,
        id: id,
      );

  Future<void> deleteTile({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteTile(domain: domain, id: id);

  Stream<dynamic> alert(String domain) => _databaseClient.alert(domain);

  Future<void> saveAlert({
    required String domain,
    required String name,
    required String deviceId,
    required bool relate,
    required String lvalue,
    required String rvalue,
    String? id,
  }) async =>
      _databaseClient.saveAlert(
        domain: domain,
        name: name,
        deviceId: deviceId,
        relate: relate,
        lvalue: lvalue,
        rvalue: rvalue,
        id: id,
      );

  Future<void> deleteAlert({
    required String domain,
    required String id,
  }) async =>
      _databaseClient.deleteAlert(domain: domain, id: id);

  Stream<dynamic> alertRecord(String domain) =>
      _databaseClient.alertRecord(domain);

  Future<void> saveAlertRecord({
    required String domain,
    required String alertId,
    required DateTime time,
    required String value,
    String? id,
  }) async =>
      _databaseClient.saveAlertRecord(
        domain: domain,
        alertId: alertId,
        time: time,
        value: value,
        id: id,
      );

  Stream<dynamic> record(String domain) => _databaseClient.record(domain);

  Future<void> saveRecord({
    required String domain,
    required String deviceId,
    required DateTime time,
    required String value,
    String? id,
  }) async =>
      _databaseClient.saveRecord(
        domain: domain,
        deviceId: deviceId,
        time: time,
        value: value,
        id: id,
      );
}
