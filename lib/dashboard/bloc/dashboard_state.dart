part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.domain = '',
    this.isAdmin = false,
  });

  final String domain;
  final bool isAdmin;

  @override
  List<Object> get props => [domain, isAdmin];

  DashboardState copyWith({
    String? domain,
    bool? isAdmin,
  }) {
    return DashboardState(
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
