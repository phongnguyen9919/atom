part of 'broker_edit_bloc.dart';

enum BrokerEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension BrokerEditStatusX on BrokerEditStatus {
  bool isWaiting() => this == BrokerEditStatus.waiting;
  bool isSuccess() => this == BrokerEditStatus.success;
  bool isFailure() => this == BrokerEditStatus.failure;
}

class BrokerEditState extends Equatable {
  const BrokerEditState({
    required this.isAdmin,
    required this.domain,
    this.status = BrokerEditStatus.normal,
    required this.isEdit,
    this.name = '',
    this.url = '',
    this.port = '',
    this.account,
    this.password,
    this.initialBroker,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;

  // initial
  final Broker? initialBroker;

  // input
  final String name;
  final String url;
  final String port;
  final String? account;
  final String? password;

  // status
  final BrokerEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props => [
        isAdmin,
        domain,
        isEdit,
        initialBroker,
        name,
        url,
        port,
        account,
        password,
        status,
        error
      ];

  BrokerEditState copyWith({
    bool? isAdmin,
    String? domain,
    String? name,
    String? url,
    String? port,
    String? account,
    String? password,
    bool? isEdit,
    BrokerEditStatus? status,
    Broker? initialBroker,
    String? Function()? error,
  }) {
    return BrokerEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      domain: domain ?? this.domain,
      name: name ?? this.name,
      url: url ?? this.url,
      port: port ?? this.port,
      account: account ?? this.account,
      password: password ?? this.password,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialBroker: initialBroker ?? this.initialBroker,
      error: error != null ? error() : this.error,
    );
  }
}
