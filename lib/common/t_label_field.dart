import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TLabelField extends StatelessWidget {
  const TLabelField({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: textTheme.bodySmall!.copyWith(
          color: ColorName.XBlack,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
