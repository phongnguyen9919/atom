part of 'broker_bloc.dart';

class BrokerState extends Equatable {
  const BrokerState({
    this.domain = '',
    this.isAdmin = false,
  });

  final String domain;
  final bool isAdmin;

  @override
  List<Object> get props => [domain, isAdmin];

  BrokerState copyWith({
    String? domain,
    bool? isAdmin,
  }) {
    return BrokerState(
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
