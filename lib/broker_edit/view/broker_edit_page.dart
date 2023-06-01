import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/broker_edit/broker_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'broker_edit_view.dart';

class BrokerEditPage extends StatelessWidget {
  const BrokerEditPage({required this.initialBroker, super.key});

  final Broker? initialBroker;

  static PageRoute<void> route({
    required String domain,
    required Broker? initialBroker,
    required bool isAdmin,
    required bool isEdit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => BrokerEditBloc(
            context.read<UserRepository>(),
            domain: domain,
            isAdmin: isAdmin,
            initialBroker: initialBroker,
            isEdit: isEdit,
          ),
          child: BrokerEditPage(initialBroker: initialBroker),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: BrokerEditView(initialBroker: initialBroker),
    );
  }
}
