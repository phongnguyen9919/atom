import 'package:atom/device_edit/view/device_edit_page.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/group/group.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/group_edit/view/group_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'group_view.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key, required this.groupName});

  final String? groupName;

  static PageRoute<void> route({
    required String domain,
    required bool isAdmin,
    required Group? group,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => GroupBloc(
            context.read<UserRepository>(),
            domain: domain,
            isAdmin: isAdmin,
            group: group,
          ),
          child: GroupPage(groupName: group?.name),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAdmin = context.select((GroupBloc bloc) => bloc.state.isAdmin);
    final domain = context.select((GroupBloc bloc) => bloc.state.domain);
    final group = context.select((GroupBloc bloc) => bloc.state.group);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          group?.name ?? 'Groups',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
        backgroundColor: ColorName.XRed,
        actions: <Widget>[
          if (isAdmin && group != null)
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(GroupEditPage.route(
                  domain: domain,
                  isAdmin: isAdmin,
                  parentId: group.groupID,
                  initialName: group.name,
                  initialId: group.id,
                  isEdit: true)),
            ),
          if (isAdmin)
            IconButton(
              icon: const Icon(
                Icons.create_new_folder_outlined,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(GroupEditPage.route(
                  domain: domain,
                  isAdmin: isAdmin,
                  parentId: group?.id,
                  initialName: null,
                  initialId: null,
                  isEdit: true)),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: isAdmin
                ? IconButton(
                    icon: const Icon(
                      Icons.note_add_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        Navigator.of(context).push(DeviceEditPage.route(
                      domain: domain,
                      initialId: null,
                      parentId: group?.id,
                      isAdmin: isAdmin,
                      isEdit: true,
                      initialName: null,
                      initialTopic: null,
                      initialQos: null,
                      initialJsonPath: null,
                      initialBrokerId: null,
                      initialUnit: null,
                    )),
                  )
                : null,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: const GroupView(),
    );
  }
}
