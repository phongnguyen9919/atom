part of 'dashboard_edit_bloc.dart';

enum DashboardEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension DashboardEditStatusX on DashboardEditStatus {
  bool isWaiting() => this == DashboardEditStatus.waiting;
  bool isSuccess() => this == DashboardEditStatus.success;
  bool isFailure() => this == DashboardEditStatus.failure;
}

class DashboardEditState extends Equatable {
  const DashboardEditState({
    required this.isAdmin,
    required this.domain,
    this.status = DashboardEditStatus.normal,
    required this.isEdit,
    this.name = '',
    this.initialDashboard,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;

  // initial
  final Dashboard? initialDashboard;

  // input
  final String name;

  // status
  final DashboardEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props =>
      [isAdmin, domain, isEdit, initialDashboard, name, status, error];

  DashboardEditState copyWith({
    bool? isAdmin,
    String? domain,
    String? name,
    bool? isEdit,
    DashboardEditStatus? status,
    Dashboard? initialDashboard,
    String? Function()? error,
  }) {
    return DashboardEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      domain: domain ?? this.domain,
      name: name ?? this.name,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialDashboard: initialDashboard ?? this.initialDashboard,
      error: error != null ? error() : this.error,
    );
  }
}
