part of 'dashboard_edit_bloc.dart';

abstract class DashboardEditEvent extends Equatable {
  const DashboardEditEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends DashboardEditEvent {
  const Submitted();
}

class NameChanged extends DashboardEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class IsEditChanged extends DashboardEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
