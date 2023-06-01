import 'package:atom/common/t_element.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/alert_record/alert_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AlertRecordView extends StatelessWidget {
  const AlertRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    final alertRecordStream = context.read<AlertRecordBloc>().alertRecord;
    final alerts = context.select((AlertRecordBloc bloc) => bloc.state.alerts);

    return StreamBuilder(
      stream: alertRecordStream,
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
              final matched = alerts
                  .where((element) => element.id == item['alert_id'])
                  .toList();
              final alertName = matched.isNotEmpty
                  ? matched.first.name
                  : 'Alert has not been found';
              return TElement(
                title: '$alertName: ${item["value"]}',
                // subtitle: item['password'],
                subtitle: DateFormat('hh:mm:ss  dd-MM-yyyy')
                    .format(DateTime.parse(item['time'] as String)),
                iconData: Icons.warning_outlined,
                onPressed: () {},
                isAdmin: false,
                onDeletePressed: () {},
              );
            });
        // Return your widget with the data from the snapshot
      },
    );
  }
}
