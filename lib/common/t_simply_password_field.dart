import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TSimplyPasswordField extends StatefulWidget {
  const TSimplyPasswordField({
    super.key,
    required this.initText,
    required this.onChanged,
    required this.validator,
    this.enabled = true,
    this.hasDelete = false,
  });

  final String? initText;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool hasDelete;

  @override
  State<TSimplyPasswordField> createState() => _TSimplyPasswordFieldState();
}

class _TSimplyPasswordFieldState extends State<TSimplyPasswordField> {
  late TextEditingController _controller;
  late bool visible;
  late bool hasFocus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initText != null) {
      _controller.text = widget.initText!;
    }
    visible = true;
    hasFocus = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Focus(
      onFocusChange: (focus) => setState(() {
        hasFocus = focus;
      }),
      child: TextFormField(
        validator: (value) {
          if (hasFocus) {
            return null;
          } else {
            return widget.validator?.call(value);
          }
        },
        obscureText: visible,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.visiblePassword,
        controller: _controller,
        onChanged: widget.onChanged,
        cursorColor: ColorName.XBlack,
        style: textTheme.bodyMedium!.copyWith(
          color: ColorName.XBlack,
          fontWeight: FontWeight.w600,
        ),
        enabled: widget.enabled,
        // prefix icon
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          errorStyle: textTheme.labelMedium!
              .copyWith(color: ColorName.XRed, fontWeight: FontWeight.w700),
          suffixIcon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  visible = !visible;
                });
              },
              child: visible
                  ? const Icon(Icons.visibility_off, color: ColorName.XBlack)
                  : const Icon(Icons.visibility, color: ColorName.XBlack)),
          // background
          filled: true,
          fillColor: hasFocus ? ColorName.XWhite : ColorName.XWhite,
          // label
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: ColorName.XRed, width: 1.6),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: ColorName.XBlack, width: 1.6),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(color: ColorName.XRed, width: 1.6),
          ),
        ),
      ),
    );
  }
}
