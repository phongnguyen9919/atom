import 'package:atom/gen/colors.gen.dart';
import 'package:atom/device/device.dart';
import 'package:atom/packages/models/device.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/device_edit/view/device_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_view.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  static PageRoute<void> route({
    required String domain,
    required bool isAdmin,
    required Device device,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => DeviceBloc(
            context.read<UserRepository>(),
            domain: domain,
            isAdmin: isAdmin,
            device: device,
          ),
          child: const DevicePage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAdmin = context.select((DeviceBloc bloc) => bloc.state.isAdmin);
    final domain = context.select((DeviceBloc bloc) => bloc.state.domain);
    final device = context.select((DeviceBloc bloc) => bloc.state.device);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          device.name,
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
        backgroundColor: ColorName.XRed,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(DeviceEditPage.route(
                domain: domain,
                isAdmin: isAdmin,
                initialId: device.id,
                parentId: device.groupID,
                initialName: device.name,
                initialTopic: device.topic,
                initialBrokerId: device.brokerID,
                initialJsonPath: device.jsonPath,
                initialQos: device.qos,
                initialUnit: device.unit,
                isEdit: false,
              )),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: const DeviceView(),
    );
  }
}
