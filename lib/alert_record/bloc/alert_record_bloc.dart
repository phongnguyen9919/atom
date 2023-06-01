import 'dart:async';

import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alert_record_event.dart';
part 'alert_record_state.dart';

class AlertRecordBloc extends Bloc<AlertRecordEvent, AlertRecordState> {
  AlertRecordBloc(this._userRepository,
      {required String domain, required bool isAdmin})
      : super(AlertRecordState(domain: domain, isAdmin: isAdmin)) {
    on<Started>(_onStarted);
    on<AlertChanged>(_onAlertChanged);
  }

  final UserRepository _userRepository;

  StreamSubscription<dynamic>? _alertSubsription;

  Stream<dynamic> get alertRecord => _userRepository.alertRecord(state.domain);
  Stream<dynamic> get alert => _userRepository.alert(state.domain);

  void _onStarted(Started event, Emitter<AlertRecordState> emit) {
    _alertSubsription = _userRepository.alert(state.domain).listen((data) {
      final alerts = (data as List<dynamic>)
          .map((e) => Alert.fromJson(e as Map<String, dynamic>))
          .toList();
      add(AlertChanged(alerts: alerts));
    });
  }

  void _onAlertChanged(AlertChanged event, Emitter<AlertRecordState> emit) {
    emit(state.copyWith(alerts: event.alerts));
  }

  @override
  Future<void> close() {
    _alertSubsription?.cancel();
    return super.close();
  }
}
