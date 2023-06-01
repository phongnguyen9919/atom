import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TCard extends StatelessWidget {
  const TCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.onDeletePressed,
  });

  final String title;
  final String subtitle;
  final void Function() onPressed;
  final void Function() onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: ColorName.gold200,
        foregroundColor: ColorName.gold400,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorName.neural700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodyLarge!.copyWith(
                      color: ColorName.neural700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
