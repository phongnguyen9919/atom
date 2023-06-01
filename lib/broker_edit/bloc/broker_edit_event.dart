part of 'broker_edit_bloc.dart';

abstract class BrokerEditEvent extends Equatable {
  const BrokerEditEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends BrokerEditEvent {
  const Submitted();
}

class NameChanged extends BrokerEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class UrlChanged extends BrokerEditEvent {
  const UrlChanged(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}

class PortChanged extends BrokerEditEvent {
  const PortChanged(this.port);

  final String port;

  @override
  List<Object> get props => [port];
}

class AccountChanged extends BrokerEditEvent {
  const AccountChanged(this.account);

  final String account;

  @override
  List<Object> get props => [account];
}

class PasswordChanged extends BrokerEditEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class IsEditChanged extends BrokerEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
