part of 'alert_record_bloc.dart';

class AlertRecordState extends Equatable {
  const AlertRecordState({
    this.domain = '',
    this.isAdmin = false,
    this.alerts = const [],
  });

  final String domain;
  final bool isAdmin;

  final List<Alert> alerts;

  @override
  List<Object> get props => [domain, isAdmin, alerts];

  AlertRecordState copyWith({
    String? domain,
    bool? isAdmin,
    List<Alert>? alerts,
  }) {
    return AlertRecordState(
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
      alerts: alerts ?? this.alerts,
    );
  }
}
