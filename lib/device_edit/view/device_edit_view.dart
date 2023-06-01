import 'package:atom/common/t_label_field.dart';
import 'package:atom/common/t_simply_text_field.dart';
import 'package:atom/common/t_snackbar.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/device_edit/bloc/device_edit_bloc.dart';
import 'package:atom/packages/models/models.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DeviceEditView extends StatelessWidget {
  const DeviceEditView({
    super.key,
    required this.initialName,
    required this.initialTopic,
    required this.initialQos,
    required this.initialJsonPath,
    required this.initialBrokerId,
    required this.initialUnit,
    required this.initialBrokers,
  });

  final String? initialName;
  final String? initialTopic;
  final int? initialQos;
  final String? initialJsonPath;
  final String? initialBrokerId;
  final String? initialUnit;
  final List<Broker> initialBrokers;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final isEdit = context.select((DeviceEditBloc bloc) => bloc.state.isEdit);

    final matched = initialBrokers
        .where((element) => element.id == initialBrokerId)
        .toList();
    final initialBrokerName =
        matched.isNotEmpty ? matched.first.name : 'Select broker';

    return BlocListener<DeviceEditBloc, DeviceEditState>(
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
                  content: state.initialId == null
                      ? 'New device has been created'
                      : 'Device has been updated',
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
                          initText: initialName,
                          enabled: isEdit,
                          onChanged: (name) => context
                              .read<DeviceEditBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value must not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Broker'),
                        TDropdown(
                          items: initialBrokers
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
                          initialName: initialBrokerName,
                          onChanged: (brokerId) {
                            if (brokerId != null) {
                              context
                                  .read<DeviceEditBloc>()
                                  .add(BrokerIdChanged(brokerId as String));
                            }
                          },
                          validator: (value) {
                            if (value == null &&
                                initialBrokerName == 'Select broker') {
                              return 'Please select broker';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Topic'),
                        TSimplyTextField(
                          initText: initialTopic,
                          enabled: isEdit,
                          onChanged: (topic) => context
                              .read<DeviceEditBloc>()
                              .add(TopicChanged(topic)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value must not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Quality of Service'),
                        TDropdown(
                          items: ['0', '1', '2']
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: ColorName.XBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          initialName: initialQos?.toString() ?? '0',
                          onChanged: (qos) {
                            if (qos != null) {
                              context
                                  .read<DeviceEditBloc>()
                                  .add(QosChanged(int.parse(qos as String)));
                            }
                          },
                          validator: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Json path (optional)'),
                        TSimplyTextField(
                          initText: initialJsonPath,
                          enabled: isEdit,
                          onChanged: (jsonPath) => context
                              .read<DeviceEditBloc>()
                              .add(JsonPathChanged(jsonPath)),
                          validator: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Unit (optional)'),
                        TSimplyTextField(
                          initText: initialUnit,
                          enabled: isEdit,
                          onChanged: (topic) => context
                              .read<DeviceEditBloc>()
                              .add(UnitChanged(topic)),
                          validator: (value) {
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

class _Header extends StatelessWidget {
  const _Header(this.formKey);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final isEdit = context.select((DeviceEditBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((DeviceEditBloc bloc) => bloc.state.isAdmin);

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
                        context.read<DeviceEditBloc>().add(const Submitted());
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
                            .read<DeviceEditBloc>()
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
    final initialId =
        context.select((DeviceEditBloc bloc) => bloc.state.initialId);
    final isEdit = context.select((DeviceEditBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          initialId == null
              ? 'New device'
              : isEdit
                  ? 'Edit device'
                  : 'Device detail',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
      ],
    );
  }
}
