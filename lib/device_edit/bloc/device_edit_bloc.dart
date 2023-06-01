import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_edit_event.dart';
part 'device_edit_state.dart';

class DeviceEditBloc extends Bloc<DeviceEditEvent, DeviceEditState> {
  DeviceEditBloc(
    this._userRepository, {
    required String domain,
    required bool isAdmin,
    required bool isEdit,
    required String? parentId,
    required String? initialId,
    required String? initialName,
    required String? initialTopic,
    required int? initialQos,
    required String? initialJsonPath,
    required String? initialBrokerId,
    required String? initialUnit,
  }) : super(DeviceEditState(
          isAdmin: isAdmin,
          domain: domain,
          parentId: parentId,
          isEdit: isEdit,
          initialId: initialId,
          name: initialName ?? '',
          topic: initialTopic ?? '',
          qos: initialQos ?? 0,
          jsonPath: initialJsonPath ?? '',
          brokerId: initialBrokerId ?? '',
          unit: initialUnit,
        )) {
    on<GetBrokers>(_onGetBrokers);
    on<Submitted>(_onSubmitted);
    on<NameChanged>(_onNameChanged);
    on<TopicChanged>(_onTopicChanged);
    on<QosChanged>(_onQosChanged);
    on<BrokerIdChanged>(_onBrokerIdChanged);
    on<JsonPathChanged>(_onJsonPathChanged);
    on<UnitChanged>(_onUnitChanged);
    on<IsEditChanged>(_onIsEditChanged);
  }

  final UserRepository _userRepository;

  Future<void> _onGetBrokers(
      GetBrokers event, Emitter<DeviceEditState> emit) async {
    try {
      final json = await _userRepository.getBrokers(state.domain);
      final brokers =
          json.map((e) => Broker.fromJson(e as Map<String, dynamic>)).toList();
      emit(state.copyWith(brokers: brokers));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: DeviceEditStatus.failure, error: () => err));
    }
  }

  void _onIsEditChanged(IsEditChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onTopicChanged(TopicChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(topic: event.topic));
  }

  void _onQosChanged(QosChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(qos: event.qos));
  }

  void _onBrokerIdChanged(
      BrokerIdChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(brokerId: event.brokerId));
  }

  void _onJsonPathChanged(
      JsonPathChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(jsonPath: event.jsonPath));
  }

  void _onUnitChanged(UnitChanged event, Emitter<DeviceEditState> emit) {
    emit(state.copyWith(unit: event.unit));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<DeviceEditState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DeviceEditStatus.waiting));
      await _userRepository.saveDevice(
        domain: state.domain,
        id: state.initialId,
        name: state.name,
        groupId: state.parentId,
        topic: state.topic,
        qos: state.qos,
        brokerId: state.brokerId,
        jsonPath: state.jsonPath,
        unit: state.unit,
      );
      emit(state.copyWith(status: DeviceEditStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(state.copyWith(status: DeviceEditStatus.failure, error: () => err));
    }
  }
}
