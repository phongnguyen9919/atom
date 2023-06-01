import 'package:atom/common/t_element.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/broker/broker.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/broker_edit/view/broker_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrokerView extends StatelessWidget {
  const BrokerView({super.key});

  @override
  Widget build(BuildContext context) {
    final brokerStream = context.read<BrokerBloc>().broker;
    final domain = context.select((BrokerBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((BrokerBloc bloc) => bloc.state.isAdmin);

    return StreamBuilder(
      stream: brokerStream,
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
                subtitle: '${item["url"]}:${item["port"]}',
                iconData: Icons.dns,
                onPressed: () => Navigator.of(context).push(
                    BrokerEditPage.route(
                        domain: domain,
                        isAdmin: isAdmin,
                        initialBroker: Broker.fromJson(item),
                        isEdit: false)),
                isAdmin: isAdmin,
                onDeletePressed: () =>
                    context.read<BrokerBloc>().add(DeleteBroker(item['id'])),
              );
            });
        // Return your widget with the data from the snapshot
      },
    );
  }
}
