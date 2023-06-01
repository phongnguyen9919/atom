import 'package:atom/gen/colors.gen.dart';
import 'package:atom/login/login.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Widget page() => BlocProvider(
        create: (context) => LoginBloc(context.read<UserRepository>()),
        child: const LoginPage(),
      );

  static PageRoute<void> route() => PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => LoginBloc(context.read<UserRepository>()),
          child: const LoginPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: LoginView(),
    );
  }
}
