import 'package:atom/common/t_element.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/member/member.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/user_edit/view/user_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberView extends StatelessWidget {
  const MemberView({super.key});

  @override
  Widget build(BuildContext context) {
    final memberStream = context.read<MemberBloc>().member;
    final domain = context.select((MemberBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((MemberBloc bloc) => bloc.state.isAdmin);

    return StreamBuilder(
      stream: memberStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data as List<dynamic>;
        return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(
                  color: ColorName.XBlack.withAlpha(106),
                  thickness: 1.2,
                ),
            itemBuilder: (_, index) {
              final item = data[index];
              return TElement(
                title: item['username'],
                // subtitle: item['password'],
                subtitle: item['is_admin'] ? 'Admin' : 'Member',
                iconData: Icons.person_2_outlined,
                onPressed: () => Navigator.of(context).push(
                    EditMemberPage.route(
                        domain: domain,
                        isAdmin: isAdmin,
                        initialUser: User.fromJson(item),
                        isEdit: false)),
                isAdmin: isAdmin,
                onDeletePressed: () =>
                    context.read<MemberBloc>().add(DeleteMember(item['id'])),
              );
            });
      },
    );
  }
}
