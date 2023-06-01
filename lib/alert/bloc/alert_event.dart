part of 'alert_bloc.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();
}

class DeleteAlert extends AlertEvent {
  const DeleteAlert(this.alertId);

  final String alertId;

  @override
  List<Object> get props => [alertId];
}
