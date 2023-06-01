import 'package:atom/dashboard/dashboard.dart';
import 'package:atom/dashboard_edit/view/dashboard_edit_page.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_view.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static PageRoute<void> route(String domain, bool isAdmin) =>
      PageRouteBuilder<void>(
        // transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => DashboardBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin),
          child: const DashboardPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAdmin = context.select((DashboardBloc bloc) => bloc.state.isAdmin);
    final domain = context.select((DashboardBloc bloc) => bloc.state.domain);

    return Scaffold(
      backgroundColor: ColorName.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
        backgroundColor: ColorName.XRed,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: isAdmin
                ? IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).push(
                        DashboardEditPage.route(
                            domain: domain,
                            isAdmin: isAdmin,
                            initialDashboard: null,
                            isEdit: true)),
                  )
                : null,
          )
        ],
      ),
      body: const DashboardView(),
    );
  }
}
