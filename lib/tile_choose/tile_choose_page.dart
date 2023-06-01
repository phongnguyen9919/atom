import 'package:atom/common/t_element.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/tile_type.dart';
import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:atom/tile/tile.dart';
import 'package:atom/tile_edit/view/tile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TileChoosePage extends StatelessWidget {
  const TileChoosePage({super.key, required this.dashboardId});

  final String dashboardId;

  static PageRoute<void> route(
          {required String domain,
          required bool isAdmin,
          required String dashboardId}) =>
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => TileBloc(context.read<UserRepository>(),
              domain: domain, isAdmin: isAdmin),
          child: TileChoosePage(dashboardId: dashboardId),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final domain = context.select((TileBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((TileBloc bloc) => bloc.state.isAdmin);

    return Scaffold(
      backgroundColor: ColorName.XWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: Text(
          'Pick new tile',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
        backgroundColor: ColorName.XRed,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ListView.separated(
          itemCount: TileType.values.length,
          separatorBuilder: (_, __) => Divider(
            color: ColorName.XBlack.withAlpha(106),
            thickness: 1.2,
          ),
          itemBuilder: (_, index) {
            final type = TileType.values[index];
            return TElement(
              title: type.value,
              subtitle: '',
              iconData: [
                Icons.text_fields,
                Icons.toggle_off,
                Icons.vertical_align_bottom,
                Icons.show_chart,
              ][index],
              onPressed: () => Navigator.of(context).push(TileEditPage.route(
                domain: domain,
                isAdmin: isAdmin,
                initialTile: null,
                dashboardId: dashboardId,
                type: type,
                isEdit: true,
              )),
              isAdmin: false,
              onDeletePressed: () {},
            );
          },
        ),
      ),
    );
  }
}
