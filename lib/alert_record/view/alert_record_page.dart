import 'package:atom/gen/colors.gen.dart';
import 'package:atom/alert_record/alert_record.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'alert_record_view.dart';

class AlertRecordPage extends StatelessWidget {
  const AlertRecordPage({super.key});

  static PageRoute<void> route(
          {required String domain, required bool isAdmin}) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => AlertRecordBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin)
            ..add(const Started()),
          child: const AlertRecordPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'Alert Record',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
        backgroundColor: ColorName.XRed,
      ),
      resizeToAvoidBottomInset: true,
      body: const AlertRecordView(),
    );
  }
}
