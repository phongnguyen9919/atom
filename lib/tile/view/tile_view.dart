import 'package:atom/dashboard_edit/dashboard_edit.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/tile/tile.dart';
import 'package:atom/tile_choose/tile_choose_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TileView extends StatelessWidget {
  const TileView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TileBloc>().state;

    final selectedDashboardName = state.selectedDashboardName;
    final showTile = state.showTile;

    // get tiles value view
    final tileValueView = state.tileValueView;
    final deviceView = state.deviceView;
    final brokerStatusView = state.brokerStatusView;

    final isAdmin = state.isAdmin;
    final domain = state.domain;
    final selectedDashboardId = state.selectedDashboardId;

    // tile width
    final mediaWidth = MediaQuery.of(context).size.width;
    final tileWidth = (mediaWidth - 24) / 2;

    return BlocListener<TileBloc, TileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isWaiting()) {
          if (!context.loaderOverlay.visible) {
            context.loaderOverlay.show();
          }
        } else {
          if (context.loaderOverlay.visible) {
            context.loaderOverlay.hide();
          }
          if (state.status.isSuccess()) {
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          } else if (state.status.isFailure()) {
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          }
        }
      },
      child: ColoredBox(
        color: ColorName.XWhite,
        child: Column(
          children: [
            _Header(selectedDashboardName),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: showTile.map<Widget>(
                      (tile) {
                        final device = deviceView[tile.deviceId];

                        return TileWidget(
                          tile: tile,
                          width: tileWidth,
                          value: tileValueView[tile.id],
                          status: brokerStatusView[device?.brokerID],
                          isAdmin: isAdmin,
                          domain: domain,
                          unit: device?.unit,
                          dashboardId: selectedDashboardId,
                        );
                      },
                    ).toList()),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.dashboardName);

  final String dashboardName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final domain = context.select((TileBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((TileBloc bloc) => bloc.state.isAdmin);
    final selectedDashboardId =
        context.select((TileBloc bloc) => bloc.state.selectedDashboardId);
    final selectedDashboard =
        context.select((TileBloc bloc) => bloc.state.selectedDashboard);

    return Container(
      height: 72,
      color: ColorName.XRed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 4, 0),
            child: TMenuButton(),
          ),
          Text(
            dashboardName,
            style:
                textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isAdmin && selectedDashboardId != '')
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).push(
                      DashboardEditPage.route(
                          domain: domain,
                          isAdmin: isAdmin,
                          initialDashboard: selectedDashboard,
                          isEdit: true)),
                ),
              if (isAdmin && selectedDashboardId != '')
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () => context
                      .read<TileBloc>()
                      .add(DeleteDashboard(dashboardId: selectedDashboardId)),
                ),
              if (isAdmin)
                IconButton(
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.of(context).push(DashboardEditPage.route(
                    domain: domain,
                    isAdmin: isAdmin,
                    initialDashboard: null,
                    isEdit: true,
                  )),
                ),
              if (isAdmin && selectedDashboardId != '')
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        Navigator.of(context).push(TileChoosePage.route(
                      domain: domain,
                      isAdmin: isAdmin,
                      dashboardId: selectedDashboardId,
                    )),
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}
