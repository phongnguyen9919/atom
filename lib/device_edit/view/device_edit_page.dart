import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/device_edit/device_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_edit_view.dart';

class DeviceEditPage extends StatelessWidget {
  const DeviceEditPage({
    required this.initialName,
    required this.initialTopic,
    required this.initialQos,
    required this.initialJsonPath,
    required this.initialBrokerId,
    required this.initialUnit,
    super.key,
  });

  final String? initialName;
  final String? initialTopic;
  final int? initialQos;
  final String? initialJsonPath;
  final String? initialBrokerId;
  final String? initialUnit;

  static PageRoute<void> route({
    required String domain,
    required String? initialId,
    required String? parentId,
    required bool isAdmin,
    required bool isEdit,
    required String? initialName,
    required String? initialTopic,
    required int? initialQos,
    required String? initialJsonPath,
    required String? initialBrokerId,
    required String? initialUnit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => DeviceEditBloc(context.read<UserRepository>(),
              domain: domain,
              isAdmin: isAdmin,
              parentId: parentId,
              initialId: initialId,
              initialName: initialName,
              initialTopic: initialTopic,
              initialQos: initialQos,
              initialJsonPath: initialJsonPath,
              initialBrokerId: initialBrokerId,
              initialUnit: initialUnit,
              isEdit: isEdit)
            ..add(const GetBrokers()),
          child: DeviceEditPage(
            initialName: initialName,
            initialTopic: initialTopic,
            initialQos: initialQos,
            initialJsonPath: initialJsonPath,
            initialBrokerId: initialBrokerId,
            initialUnit: initialUnit,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final brokers = context.select((DeviceEditBloc bloc) => bloc.state.brokers);

    return Scaffold(
        backgroundColor: ColorName.XWhite,
        resizeToAvoidBottomInset: true,
        body: DeviceEditView(
          initialName: initialName,
          initialTopic: initialTopic,
          initialQos: initialQos,
          initialJsonPath: initialJsonPath,
          initialBrokerId: initialBrokerId,
          initialUnit: initialUnit,
          initialBrokers: brokers,
        ));
  }
}
