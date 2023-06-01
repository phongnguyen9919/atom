import 'package:atom/gen/assets.gen.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class TTextField extends StatefulWidget {
  const TTextField({
    super.key,
    required this.initText,
    required this.labelText,
    required this.onChanged,
    required this.validator,
    this.picture,
    this.enabled = true,
    this.textInputType = TextInputType.text,
  });

  final String labelText;
  final String? initText;
  final SvgGenImage? picture;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType textInputType;

  @override
  State<TTextField> createState() => _TTextFieldState();
}

class _TTextFieldState extends State<TTextField> {
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
        cursorColor: ColorName.sky300,
        style: textTheme.bodyMedium!.copyWith(
          color: ColorName.neural700,
          fontWeight: FontWeight.w600,
        ),
        enabled: widget.enabled,
        // prefix icon
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          errorStyle: textTheme.labelMedium!
              .copyWith(color: ColorName.wine300, fontWeight: FontWeight.w700),
          prefixIconConstraints: widget.picture != null
              ? const BoxConstraints(
                  minWidth: 56,
                )
              : null,
          prefixIcon: widget.picture != null
              ? widget.picture!.svg(
                  fit: BoxFit.scaleDown,
                  color: widget.enabled
                      ? ColorName.neural600
                      : ColorName.neural500,
                )
              : const SizedBox.shrink(),
          // background
          filled: true,
          fillColor: hasFocus ? ColorName.neural300 : ColorName.neural200,
          // label
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: widget.labelText,
          labelStyle:
              textTheme.bodyMedium!.copyWith(color: ColorName.neural600),
          focusedBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            borderSide: BorderSide(color: ColorName.neural500, width: 3),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            borderSide: BorderSide(color: ColorName.neural200, width: 3),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            borderSide: BorderSide(color: ColorName.neural400, width: 3),
          ),
          errorBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            borderSide: BorderSide(color: ColorName.wine300, width: 3),
          ),
        ),
      ),
    );
  }
}
