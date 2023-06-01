import 'package:atom/gen/colors.gen.dart';
import 'package:atom/tile/tile.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';

class TMenuButton extends StatelessWidget {
  const TMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = context.select((TileBloc bloc) => bloc.state.isReadRecord);

    if (!isRead) {
      return badges.Badge(
        position: badges.BadgePosition.topEnd(top: 6, end: 0),
        badgeContent: null,
        badgeStyle: const badges.BadgeStyle(badgeColor: ColorName.XWhite),
        child: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      );
    }

    return IconButton(
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}
