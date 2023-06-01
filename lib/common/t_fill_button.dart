import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TFillButton extends StatelessWidget {
  const TFillButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding = 16,
  });

  final void Function() onPressed;
  final String title;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorName.XRed,
        padding: EdgeInsets.zero,
        backgroundColor: ColorName.XRed,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Text(
          title,
          style: textTheme.labelLarge!.copyWith(
            color: ColorName.XWhite,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
