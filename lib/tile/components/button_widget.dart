import 'dart:convert';

import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/tile/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.tile,
    required this.value,
  });

  final Tile tile;
  final String value;

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final decoded = jsonDecode(tile.lob) as Map<String, dynamic>;
    final sentValue = decoded['value']! as String;

    return Expanded(
      child: Center(
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.read<TileBloc>().add(
              GatewayPublishRequested(
                deviceID: tile.deviceId,
                value: int.tryParse(sentValue).toString(),
              ),
            ),
        child: const Icon(
          Icons.vertical_align_bottom,
          size: 64,
          color: ColorName.XBlack,
        ),
      )),
    );
  }
}
