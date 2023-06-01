part of 'alert_record_bloc.dart';

abstract class AlertRecordEvent extends Equatable {
  const AlertRecordEvent();
  @override
  List<Object> get props => [];
}

class Started extends AlertRecordEvent {
  const Started();
}

class AlertChanged extends AlertRecordEvent {
  const AlertChanged({required this.alerts});

  final List<Alert> alerts;

  @override
  List<Object> get props => [alerts];
}
