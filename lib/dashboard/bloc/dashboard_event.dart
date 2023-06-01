part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class DeleteDashboard extends DashboardEvent {
  const DeleteDashboard(this.dashboardId);

  final String dashboardId;

  @override
  List<Object> get props => [dashboardId];
}
