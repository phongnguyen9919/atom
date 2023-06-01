import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TSimplyTextField extends StatefulWidget {
  const TSimplyTextField({
    super.key,
    required this.initText,
    required this.onChanged,
    required this.validator,
    this.enabled = true,
    this.textInputType = TextInputType.text,
  });

  final String? initText;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType textInputType;

  @override
  State<TSimplyTextField> createState() => _TSimplyTextFieldState();
}

class _TSimplyTextFieldState extends State<TSimplyTextField> {
  late TextEditingController _controller;
  late bool hasFocus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initText != null) {
      _controller.text = widget.initText!;
    }
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.textInputType,
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
          // prefixIcon: const SizedBox.shrink(),
          // background
          filled: true,
          fillColor: hasFocus ? ColorName.XWhite : ColorName.XWhite,
          // label
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            borderSide: BorderSide(color: ColorName.XRed, width: 1.6),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            // borderSide: BorderSide(color: ColorName.XBlack, width: 1.6),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            borderSide: BorderSide(color: ColorName.XBlack, width: 1.6),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            borderSide: BorderSide(color: ColorName.XRed, width: 1.6),
          ),
        ),
      ),
    );
  }
}
