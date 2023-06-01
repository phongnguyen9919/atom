import 'package:atom/dashboard/bloc/dashboard_bloc.dart';
import 'package:atom/dashboard_edit/view/dashboard_edit_page.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/t_element.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardStream = context.read<DashboardBloc>().dashboard;
    final domain = context.select((DashboardBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((DashboardBloc bloc) => bloc.state.isAdmin);

    return StreamBuilder(
      stream: dashboardStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data as List<dynamic>;
        return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(
                  color: ColorName.XBlack.withAlpha(106),
                  thickness: 1.2,
                ),
            itemBuilder: (_, index) {
              final item = data[index];
              return TElement(
                title: item['name'],
                // subtitle: item['password'],
                subtitle: '',
                iconData: Icons.dashboard_outlined,
                onPressed: () => Navigator.of(context).push(
                    DashboardEditPage.route(
                        domain: domain,
                        isAdmin: isAdmin,
                        initialDashboard: Dashboard.fromJson(item),
                        isEdit: false)),
                isAdmin: isAdmin,
                onDeletePressed: () => context
                    .read<DashboardBloc>()
                    .add(DeleteDashboard(item['id'])),
              );
            });
      },
    );
  }
}
