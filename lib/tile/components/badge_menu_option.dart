import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BadgeMenuOption extends StatelessWidget {
  const BadgeMenuOption({
    required this.title,
    required this.iconData,
    required this.showBadge,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool showBadge;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24),
      leading: showBadge
          ? badges.Badge(
              position: badges.BadgePosition.topEnd(top: -6, end: -10),
              badgeContent: null,
              badgeStyle: const badges.BadgeStyle(badgeColor: ColorName.XWhite),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            )
          : Icon(
              iconData,
              color: ColorName.XWhite,
            ),
      title: Text(
        title,
        style: textTheme.labelLarge!.copyWith(
          color: ColorName.XWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap.call();
      },
    );
  }
}
