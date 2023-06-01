import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/dashboard_edit/dashboard_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_edit_view.dart';

class DashboardEditPage extends StatelessWidget {
  const DashboardEditPage({required this.initialDashboard, super.key});

  final Dashboard? initialDashboard;

  static PageRoute<void> route({
    required String domain,
    required Dashboard? initialDashboard,
    required bool isAdmin,
    required bool isEdit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => DashboardEditBloc(context.read<UserRepository>(),
              domain: domain,
              isAdmin: isAdmin,
              initialDashboard: initialDashboard,
              isEdit: isEdit),
          child: DashboardEditPage(initialDashboard: initialDashboard),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: DashboardEditView(initialDashboard: initialDashboard),
    );
  }
}
