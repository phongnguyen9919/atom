import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/user_edit/user_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_edit_view.dart';

class EditMemberPage extends StatelessWidget {
  const EditMemberPage({required this.initialUser, super.key});

  final User? initialUser;

  static PageRoute<void> route({
    required String domain,
    required User? initialUser,
    required bool isAdmin,
    required bool isEdit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => UserEditBloc(context.read<UserRepository>(),
              domain: domain,
              isAdmin: isAdmin,
              initialUser: initialUser,
              isEdit: isEdit),
          child: EditMemberPage(initialUser: initialUser),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: EditMemberView(initialUser: initialUser),
    );
  }
}
