import 'dart:convert';

import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/tile/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({
    super.key,
    required this.tile,
    required this.value,
  });

  final Tile tile;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final decoded = jsonDecode(tile.lob) as Map<String, dynamic>;
    final left = (decoded['left']!).toString();
    final right = (decoded['right']!).toString();
    final isActiveLeft = value == left;
    final isActiveRight = value == right;

    // param
    const paddingCoefficient = 0.2;
    const spacingCoefficient = 0.075;
    const aspectRatio = 1.75;

    return Expanded(
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (isActiveLeft) {
              context.read<TileBloc>().add(
                    GatewayPublishRequested(
                      deviceID: tile.deviceId,
                      value: int.tryParse(right).toString(),
                    ),
                  );
            } else if (isActiveRight) {
              context.read<TileBloc>().add(
                    GatewayPublishRequested(
                      deviceID: tile.deviceId,
                      value: int.tryParse(left).toString(),
                    ),
                  );
            } else {
              context.read<TileBloc>().add(
                    GatewayPublishRequested(
                      deviceID: tile.deviceId,
                      value: int.tryParse(left).toString(),
                    ),
                  );
            }
          },
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final height = constraints.maxHeight;
                    final radius = height * (1 - 2 * paddingCoefficient) / 2;
                    final padding = height * paddingCoefficient;
                    late Color color;
                    if (isActiveLeft) {
                      color = ColorName.darkGray;
                    } else if (isActiveRight) {
                      color = ColorName.XRed;
                    } else {
                      color = ColorName.lightGray;
                    }
                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              BorderRadius.all(Radius.circular(radius)),
                        ),
                        duration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                ),
              ),
              AspectRatio(
                aspectRatio: aspectRatio,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final height = constraints.maxHeight;
                    final width = constraints.maxWidth;
                    final radius = height *
                        (1 - 2 * spacingCoefficient - 2 * paddingCoefficient);
                    final spacing = height * spacingCoefficient;
                    final padding = height * paddingCoefficient;
                    late double paddingLeft;
                    if (isActiveLeft) {
                      paddingLeft = spacing;
                    } else if (isActiveRight) {
                      paddingLeft = width - 2 * padding - spacing - radius;
                    } else {
                      paddingLeft = spacing;
                    }
                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: AnimatedContainer(
                        alignment: Alignment.topLeft,
                        padding:
                            EdgeInsets.fromLTRB(paddingLeft, spacing, 0, 0),
                        duration: const Duration(milliseconds: 400),
                        child: Container(
                          height: radius,
                          width: radius,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorName.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
