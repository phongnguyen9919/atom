import 'package:atom/common/t_label_field.dart';
import 'package:atom/common/t_simply_text_field.dart';
import 'package:atom/common/t_snackbar.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/alert_edit/bloc/alert_edit_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AlertEditView extends StatelessWidget {
  const AlertEditView({
    super.key,
    required this.initialAlert,
    required this.initialDevices,
  });

  final Alert? initialAlert;
  final List<Device> initialDevices;

  @override
  Widget build(BuildContext context) {
    // get text theme
    final textTheme = Theme.of(context).textTheme;
    // create form key
    final formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final isEdit = context.select((AlertEditBloc bloc) => bloc.state.isEdit);

    final matched = initialDevices
        .where((element) => element.id == initialAlert?.deviceID)
        .toList();
    final initialDeviceName =
        matched.isNotEmpty ? matched.first.name : 'Select device';

    final initialRelation = initialAlert != null
        ? initialAlert!.relate
            ? 'AND'
            : 'OR'
        : 'Select relation';

    return BlocListener<AlertEditBloc, AlertEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isWaiting()) {
          context.loaderOverlay.show();
        } else {
          if (state.status.isSuccess()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.success(
                  context,
                  content: state.initialAlert == null
                      ? 'New Alert has been created'
                      : 'Alert has been updated',
                ),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
            Navigator.of(context).pop();
          } else if (state.status.isFailure()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.error(context, content: state.error!),
              );
            if (context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          }
        }
      },
      child: GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            SizedBox(height: paddingTop),
            _Header(formKey),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TLabelField(title: 'Name'),
                        TSimplyTextField(
                          initText: initialAlert?.name,
                          enabled: isEdit,
                          onChanged: (username) => context
                              .read<AlertEditBloc>()
                              .add(NameChanged(username)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value must not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Device'),
                        TDropdown(
                          items: initialDevices
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.id,
                                    child: Text(
                                      item.name,
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: ColorName.XBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          initialName: initialDeviceName,
                          onChanged: (deviceId) {
                            if (deviceId != null) {
                              context
                                  .read<AlertEditBloc>()
                                  .add(DeviceIdChanged(deviceId as String));
                            }
                          },
                          validator: (value) {
                            if (value == null &&
                                initialDeviceName == 'Select device') {
                              return 'Please select device';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'constrain'),
                        Row(
                          children: [
                            const Icon(
                              Icons.navigate_before,
                              color: ColorName.XBlack,
                              size: 32,
                            ),
                            Expanded(
                              child: TSimplyTextField(
                                initText: initialAlert?.lvalue,
                                textInputType: TextInputType.number,
                                enabled: isEdit,
                                onChanged: (lvalue) => context
                                    .read<AlertEditBloc>()
                                    .add(LvalueChanged(lvalue)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Value must not be null';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.navigate_next,
                              color: ColorName.XBlack,
                              size: 32,
                            ),
                            Expanded(
                              child: TSimplyTextField(
                                initText: initialAlert?.rvalue,
                                textInputType: TextInputType.number,
                                enabled: isEdit,
                                onChanged: (rvalue) => context
                                    .read<AlertEditBloc>()
                                    .add(RvalueChanged(rvalue)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Value must not be null';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Relation'),
                        TDropdown(
                          items: [true, false]
                              .map((item) => DropdownMenuItem<bool>(
                                    value: item,
                                    child: Text(
                                      item ? 'AND' : 'OR',
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: ColorName.XBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          initialName: initialRelation,
                          onChanged: (relate) {
                            if (relate != null) {
                              context
                                  .read<AlertEditBloc>()
                                  .add(RelateChanged(relate as bool));
                            }
                          },
                          validator: (value) {
                            if (value == null &&
                                initialDeviceName == 'Select relation') {
                              return 'Please select relation';
                            }
                            return null;
                          },
                        ),
                      ],
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

class _Header extends StatelessWidget {
  const _Header(this.formKey);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEdit = context.select((AlertEditBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((AlertEditBloc bloc) => bloc.state.isAdmin);

    return Container(
      height: 72,
      // padding: const EdgeInsets.symmetric(vertical: 8),
      color: ColorName.XRed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const _Title(),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: isEdit
                ? IconButton(
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        context.read<AlertEditBloc>().add(const Submitted());
                      }
                    },
                  )
                : isAdmin
                    ? IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () => context
                            .read<AlertEditBloc>()
                            .add(const IsEditChanged(isEdit: true)),
                      )
                    : null,
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final initialAlert =
        context.select((AlertEditBloc bloc) => bloc.state.initialAlert);
    final isEdit = context.select((AlertEditBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          initialAlert == null
              ? 'New alert'
              : isEdit
                  ? 'Edit alert'
                  : 'Alert detail',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
      ],
    );
  }
}

class TDropdown extends StatelessWidget {
  const TDropdown({
    required this.initialName,
    required this.items,
    required this.onChanged,
    required this.validator,
    super.key,
  });

  final String initialName;
  final List<DropdownMenuItem> items;
  final void Function(dynamic) onChanged;
  final String? Function(dynamic) validator;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DropdownButtonFormField2(
      decoration: InputDecoration(
        // contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        errorStyle: textTheme.labelMedium!
            .copyWith(color: ColorName.XRed, fontWeight: FontWeight.w700),
        // background
        filled: true,
        fillColor: ColorName.XWhite,
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
      isExpanded: true,
      hint: Text(
        initialName,
        style: textTheme.bodyMedium!.copyWith(
          color: ColorName.XBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
      items: items,
      validator: validator,
      onChanged: onChanged,
      onSaved: (value) {},
      buttonStyleData: const ButtonStyleData(
        height: 24,
        padding: EdgeInsets.only(left: 12, right: 12),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: ColorName.XBlack,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
