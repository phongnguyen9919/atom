import 'package:atom/alert/view/alert_page.dart';
import 'package:atom/alert_record/view/alert_record_page.dart';
import 'package:atom/broker/view/broker_page.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/group/view/view.dart';
import 'package:atom/login/login.dart';
import 'package:atom/member/view/member_page.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/tile/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'tile_view.dart';

class TilePage extends StatelessWidget {
  const TilePage({super.key});

  static PageRoute<void> route(String domain, bool isAdmin) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => TileBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin)
            ..add(const Started()),
          child: const TilePage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final domain = context.select((TileBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((TileBloc bloc) => bloc.state.isAdmin);
    final dashboards = context.select((TileBloc bloc) => bloc.state.dashboards);
    final isRead = context.select((TileBloc bloc) => bloc.state.isReadRecord);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        backgroundColor: ColorName.XRed,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 64),
              child: Text(
                'Atom',
                style: textTheme.headlineLarge!.copyWith(
                  color: ColorName.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            ExpansionTile(
              collapsedIconColor: ColorName.XWhite,
              iconColor: ColorName.XWhite,
              childrenPadding: const EdgeInsets.only(left: 32),
              leading: const Icon(
                Icons.dashboard,
                color: ColorName.XWhite,
              ),
              title: Text(
                'Dashboard',
                style: textTheme.labelLarge!.copyWith(
                  color: ColorName.XWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: dashboards
                  .map((dashboard) => MenuOption(
                        title: dashboard.name,
                        iconData: null,
                        onTap: () => context
                            .read<TileBloc>()
                            .add(DashboardIdChanged(dashboardId: dashboard.id)),
                      ))
                  .toList(),
            ),
            MenuOption(
              title: 'Member',
              iconData: Icons.group,
              onTap: () =>
                  Navigator.of(context).push(MemberPage.route(domain, isAdmin)),
            ),
            MenuOption(
              title: 'Broker',
              iconData: Icons.dns,
              onTap: () =>
                  Navigator.of(context).push(BrokerPage.route(domain, isAdmin)),
            ),
            MenuOption(
              title: 'Group & Device',
              iconData: Icons.list,
              onTap: () => Navigator.of(context).push(GroupPage.route(
                domain: domain,
                isAdmin: isAdmin,
                group: null,
              )),
            ),
            MenuOption(
              title: 'Alert',
              iconData: Icons.campaign_outlined,
              onTap: () => Navigator.of(context).push(AlertPage.route(
                domain: domain,
                isAdmin: isAdmin,
              )),
            ),
            BadgeMenuOption(
                title: 'Alert Record',
                showBadge: !isRead,
                iconData: Icons.sms_failed_outlined,
                onTap: () {
                  Navigator.of(context).push(AlertRecordPage.route(
                    domain: domain,
                    isAdmin: isAdmin,
                  ));
                  context
                      .read<TileBloc>()
                      .add(const IsReadChanged(isRead: true));
                }),
            MenuOption(
                title: 'Logout',
                iconData: Icons.logout,
                onTap: () async {
                  Navigator.of(context)
                      .pushAndRemoveUntil(LoginPage.route(), (route) => false);
                  await OneSignal.shared.removeExternalUserId();
                }),
          ],
        ),
      ),
      body: const ColoredBox(
        color: ColorName.XRed,
        child: SafeArea(child: TileView()),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  const MenuOption({
    required this.title,
    required this.iconData,
    required this.onTap,
    super.key,
  });

  final String title;
  final IconData? iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24),
      leading: iconData != null
          ? Icon(
              iconData,
              color: ColorName.XWhite,
            )
          : null,
      title: Text(
        title,
        style: textTheme.labelLarge!.copyWith(
          color: ColorName.XWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap.call();
      },
    );
  }
}
