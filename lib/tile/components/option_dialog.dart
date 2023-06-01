import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TOptionDialog extends StatelessWidget {
  const TOptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      children: [
        SimpleDialogOption(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Edit',
            style: textTheme.titleMedium!.copyWith(color: ColorName.XBlack),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        SimpleDialogOption(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Delete',
            style: textTheme.titleMedium!.copyWith(color: ColorName.XBlack),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
