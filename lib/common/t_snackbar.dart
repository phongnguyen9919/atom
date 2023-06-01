import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TSnackbar {
  static SnackBar success(
    BuildContext context, {
    required String content,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              decoration: const ShapeDecoration(
                shape: StadiumBorder(),
                color: ColorName.pine100,
              ),
              child: Text(
                content,
                style: textTheme.labelLarge!.copyWith(
                  color: ColorName.pine500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static SnackBar error(
    BuildContext context, {
    required String content,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            decoration: const ShapeDecoration(
              shape: StadiumBorder(),
              color: ColorName.wine200,
            ),
            child: Text(
              content,
              style: textTheme.labelLarge!.copyWith(color: ColorName.wine600),
            ),
          ),
        ],
      ),
    );
  }
}
