part of 'alert_bloc.dart';

class AlertState extends Equatable {
  const AlertState({
    this.domain = '',
    this.isAdmin = false,
  });

  final String domain;
  final bool isAdmin;

  @override
  List<Object> get props => [domain, isAdmin];

  AlertState copyWith({
    String? domain,
    bool? isAdmin,
  }) {
    return AlertState(
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
