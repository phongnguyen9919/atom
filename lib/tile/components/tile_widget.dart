import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/models/tile_type.dart';
import 'package:atom/tile/tile.dart';
import 'package:atom/tile_edit/view/tile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({
    required this.tile,
    required this.width,
    required this.value,
    required this.status,
    required this.isAdmin,
    required this.domain,
    required this.dashboardId,
    required this.unit,
    super.key,
  });

  final String domain;
  final String dashboardId;
  final String? unit;
  final Tile tile;
  final double width;
  final String? value;
  final ConnectionStatus? status;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: width,
      height: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: ColorName.white,
          foregroundColor: ColorName.XBlack,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tile.name.toUpperCase(),
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorName.XBlack,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => showDialog<bool?>(
                      context: context,
                      builder: (bContext) => const TOptionDialog(),
                    ).then((value) {
                      if (value != null) {
                        if (value) {
                          context
                              .read<TileBloc>()
                              .add(DeleteTile(tileId: tile.id));
                        } else {
                          Navigator.of(context).push(TileEditPage.route(
                            domain: domain,
                            initialTile: tile,
                            dashboardId: dashboardId,
                            type: tile.type,
                            isAdmin: isAdmin,
                            isEdit: true,
                          ));
                        }
                      }
                    }),
                  )
                ],
              ),
              if (status != null && status!.isConnecting)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                  child: Text(
                    'Connecting to broker',
                    style:
                        textTheme.labelMedium!.copyWith(color: ColorName.XRed),
                  ),
                )
              else if (status != null && status!.isConnecting)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                  child: Text(
                    'Reconnecting to broker',
                    style:
                        textTheme.labelMedium!.copyWith(color: ColorName.XRed),
                  ),
                )
              else if (status != null &&
                  status!.isConnected &&
                  tile.type == TileType.text)
                TextWidget(value: value ?? '...', unit: unit)
              else if (status != null &&
                  status!.isConnected &&
                  tile.type == TileType.toggle)
                ToggleWidget(tile: tile, value: value ?? '...')
              else if (status != null &&
                  status!.isConnected &&
                  tile.type == TileType.button)
                ButtonWidget(tile: tile, value: value ?? '...')
              else if (status != null &&
                  status!.isConnected &&
                  tile.type == TileType.line)
                LineWidget(
                  value: value ?? '...',
                  unit: unit,
                )
            ],
          ),
        ),
      ),
    );
  }
}
