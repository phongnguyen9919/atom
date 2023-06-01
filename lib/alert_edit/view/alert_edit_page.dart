import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/alert_edit/alert_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'alert_edit_view.dart';

class AlertEditPage extends StatelessWidget {
  const AlertEditPage({required this.initialAlert, super.key});

  final Alert? initialAlert;

  static PageRoute<void> route({
    required String domain,
    required Alert? initialAlert,
    required bool isAdmin,
    required bool isEdit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => AlertEditBloc(context.read<UserRepository>(),
              domain: domain,
              isAdmin: isAdmin,
              initialAlert: initialAlert,
              isEdit: isEdit)
            ..add(const GetDevices()),
          child: AlertEditPage(initialAlert: initialAlert),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final devices = context.select((AlertEditBloc bloc) => bloc.state.devices);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: AlertEditView(initialAlert: initialAlert, initialDevices: devices),
    );
  }
}
