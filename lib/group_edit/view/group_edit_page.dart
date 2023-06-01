import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/group_edit/group_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'group_edit_view.dart';

class GroupEditPage extends StatelessWidget {
  const GroupEditPage({required this.initialName, super.key});

  final String? initialName;

  static PageRoute<void> route({
    required String domain,
    required String? parentId,
    required String? initialId,
    required String? initialName,
    required bool isAdmin,
    required bool isEdit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => GroupEditBloc(context.read<UserRepository>(),
              domain: domain,
              isAdmin: isAdmin,
              parentId: parentId,
              initialId: initialId,
              isEdit: isEdit),
          child: GroupEditPage(initialName: initialName),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: GroupEditView(initialName: initialName),
    );
  }
}
