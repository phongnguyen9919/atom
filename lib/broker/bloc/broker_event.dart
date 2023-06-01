part of 'broker_bloc.dart';

abstract class BrokerEvent extends Equatable {
  const BrokerEvent();
}

class DeleteBroker extends BrokerEvent {
  const DeleteBroker(this.brokerId);

  final String brokerId;

  @override
  List<Object> get props => [brokerId];
}
