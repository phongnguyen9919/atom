import 'package:atom/gen/colors.gen.dart';
import 'package:atom/member/member.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/user_edit/view/user_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'member_view.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  static PageRoute<void> route(String domain, bool isAdmin) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => MemberBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin),
          child: const MemberPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAdmin = context.select((MemberBloc bloc) => bloc.state.isAdmin);
    final domain = context.select((MemberBloc bloc) => bloc.state.domain);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'Member',
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
                        EditMemberPage.route(
                            domain: domain,
                            isAdmin: isAdmin,
                            initialUser: null,
                            isEdit: true)),
                  )
                : null,
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: const MemberView(),
    );
  }
}
