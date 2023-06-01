import 'package:atom/common/t_element.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/alert/alert.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/alert_edit/view/alert_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertView extends StatelessWidget {
  const AlertView({super.key});

  @override
  Widget build(BuildContext context) {
    final alertStream = context.read<AlertBloc>().alert;
    final domain = context.select((AlertBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((AlertBloc bloc) => bloc.state.isAdmin);

    return StreamBuilder(
      stream: alertStream,
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
                title: item['name'],
                // subtitle: item['password'],
                subtitle: '',
                iconData: Icons.campaign_outlined,
                onPressed: () => Navigator.of(context).push(AlertEditPage.route(
                    domain: domain,
                    isAdmin: isAdmin,
                    initialAlert: Alert.fromJson(item),
                    isEdit: false)),
                isAdmin: isAdmin,
                onDeletePressed: () =>
                    context.read<AlertBloc>().add(DeleteAlert(item['id'])),
              );
            });
        // Return your widget with the data from the snapshot
      },
    );
  }
}
