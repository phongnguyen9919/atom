import 'package:atom/gen/colors.gen.dart';
import 'package:atom/alert/alert.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/alert_edit/view/alert_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'alert_view.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  static PageRoute<void> route(
          {required String domain, required bool isAdmin}) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => AlertBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin),
          child: const AlertPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAdmin = context.select((AlertBloc bloc) => bloc.state.isAdmin);
    final domain = context.select((AlertBloc bloc) => bloc.state.domain);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'Alert',
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
                        AlertEditPage.route(
                            domain: domain,
                            isAdmin: isAdmin,
                            initialAlert: null,
                            isEdit: true)),
                  )
                : null,
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: const AlertView(),
    );
  }
}
