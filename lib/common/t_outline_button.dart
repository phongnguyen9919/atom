import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TOutlineButton extends StatelessWidget {
  const TOutlineButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: ColorName.XWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.6, color: ColorName.XRed),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: textTheme.labelLarge!.copyWith(
          color: ColorName.XBlack,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
