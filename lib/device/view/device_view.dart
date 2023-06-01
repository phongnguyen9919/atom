import 'package:atom/common/t_element.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/device/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DeviceView extends StatelessWidget {
  const DeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    final recordStream = context.read<DeviceBloc>().record;
    final device = context.select((DeviceBloc bloc) => bloc.state.device);

    return StreamBuilder(
      stream: recordStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = (snapshot.data as List<dynamic>)
            .where((ele) =>
                (ele as Map<String, dynamic>)['device_id'] == device.id)
            .toList();
        return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(
                  color: ColorName.XBlack.withAlpha(106),
                  thickness: 1.2,
                ),
            itemBuilder: (_, index) {
              final item = data[index];
              return TElement(
                title: item['value'],
                // subtitle: item['password'],
                subtitle: DateFormat('hh:mm:ss  dd-MM-yyyy')
                    .format(DateTime.parse(item['time'] as String)),
                iconData: Icons.receipt_long_outlined,
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
