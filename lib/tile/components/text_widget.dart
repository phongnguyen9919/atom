import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.value,
    required this.unit,
  });

  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (unit == null) {
      return Expanded(
        child: Center(
          child: Text(
            value,
            style: textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorName.XBlack,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Center(
        child: Text(
          '$value $unit',
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorName.XBlack,
          ),
        ),
      ),
    );
  }
}
