import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TElement extends StatelessWidget {
  const TElement({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.onDeletePressed,
    required this.iconData,
    required this.isAdmin,
  });

  final String title;
  final String subtitle;
  final void Function() onPressed;
  final void Function() onDeletePressed;
  final IconData iconData;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 16),
            Icon(
              iconData,
              color: ColorName.XBlack,
            ),
            const SizedBox(width: 32),
            Container(
              alignment: Alignment.centerLeft,
              height: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorName.XBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != '') const SizedBox(height: 4),
                  if (subtitle != '')
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            subtitle,
                            style: textTheme.bodyMedium!.copyWith(
                              color: ColorName.XBlack.withAlpha(193),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            if (isAdmin)
              IconButton(
                  onPressed: onDeletePressed, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
