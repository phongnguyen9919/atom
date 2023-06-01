import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/models/tile_type.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/tile_edit/tile_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tile_edit_view.dart';

class TileEditPage extends StatelessWidget {
  const TileEditPage(
      {required this.initialTile, required this.type, super.key});

  final Tile? initialTile;
  final TileType type;

  static PageRoute<void> route({
    required String domain,
    required Tile? initialTile,
    required String dashboardId,
    required TileType type,
    required bool isAdmin,
    required bool isEdit,
  }) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => TileEditBloc(context.read<UserRepository>(),
              domain: domain,
              isAdmin: isAdmin,
              dashboardId: dashboardId,
              type: type,
              initialTile: initialTile,
              isEdit: isEdit)
            ..add(const GetDevices()),
          child: TileEditPage(initialTile: initialTile, type: type),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final devices = context.select((TileEditBloc bloc) => bloc.state.devices);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      body: TileEditView(
        initialTile: initialTile,
        type: type,
        initialDevices: devices,
      ),
    );
  }
}
