import 'package:atom/gen/colors.gen.dart';
import 'package:atom/broker/broker.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/broker_edit/view/broker_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'broker_view.dart';

class BrokerPage extends StatelessWidget {
  const BrokerPage({super.key});

  static PageRoute<void> route(String domain, bool isAdmin) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => BrokerBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin),
          child: const BrokerPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAdmin = context.select((BrokerBloc bloc) => bloc.state.isAdmin);
    final domain = context.select((BrokerBloc bloc) => bloc.state.domain);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'Broker',
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
                        BrokerEditPage.route(
                            domain: domain,
                            isAdmin: isAdmin,
                            initialBroker: null,
                            isEdit: true)),
                  )
                : null,
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: const BrokerView(),
    );
  }
}
