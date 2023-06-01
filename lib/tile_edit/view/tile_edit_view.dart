import 'dart:convert';

import 'package:atom/common/t_label_field.dart';
import 'package:atom/common/t_simply_text_field.dart';
import 'package:atom/common/t_snackbar.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/packages/models/tile_type.dart';
import 'package:atom/tile_edit/bloc/tile_edit_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TileEditView extends StatelessWidget {
  const TileEditView({
    super.key,
    required this.initialTile,
    required this.type,
    required this.initialDevices,
  });

  final Tile? initialTile;
  final TileType type;
  final List<Device> initialDevices;

  @override
  Widget build(BuildContext context) {
    // create form key
    final formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final isEdit = context.select((TileEditBloc bloc) => bloc.state.isEdit);

    final matched = initialDevices
        .where((element) => element.id == initialTile?.deviceId)
        .toList();
    final initialDeviceName =
        matched.isNotEmpty ? matched.first.name : 'Select device';

    return BlocListener<TileEditBloc, TileEditState>(
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
                  content: state.initialTile == null
                      ? 'New Tile has been created'
                      : 'Tile has been updated',
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
                          initText: initialTile?.name,
                          enabled: isEdit,
                          onChanged: (username) => context
                              .read<TileEditBloc>()
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
                          initialName: initialDeviceName,
                          initialDevices: initialDevices,
                        ),
                        if (type == TileType.button || type == TileType.toggle)
                          const SizedBox(height: 24),
                        if (type == TileType.button)
                          const TLabelField(title: 'Sent value'),
                        if (type == TileType.button)
                          TSimplyTextField(
                            initText: initialTile != null
                                ? (jsonDecode(initialTile!.lob)
                                    as Map<String, dynamic>)['value']
                                : '',
                            enabled: isEdit,
                            onChanged: (value) => context
                                .read<TileEditBloc>()
                                .add(LobChanged({'value': value})),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Value must not be null';
                              }
                              return null;
                            },
                          ),
                        if (type == TileType.toggle)
                          const TLabelField(title: 'Left value'),
                        if (type == TileType.toggle)
                          TSimplyTextField(
                            initText: initialTile != null
                                ? (jsonDecode(initialTile!.lob)
                                    as Map<String, dynamic>)['left']
                                : '',
                            enabled: isEdit,
                            onChanged: (value) {
                              context
                                  .read<TileEditBloc>()
                                  .add(LobChanged({"left": value}));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Value must not be null';
                              }
                              return null;
                            },
                          ),
                        if (type == TileType.toggle) const SizedBox(height: 24),
                        if (type == TileType.toggle)
                          const TLabelField(title: 'Right value'),
                        if (type == TileType.toggle)
                          TSimplyTextField(
                            initText: initialTile != null
                                ? (jsonDecode(initialTile!.lob)
                                    as Map<String, dynamic>)['right']
                                : '',
                            enabled: isEdit,
                            onChanged: (value) {
                              context
                                  .read<TileEditBloc>()
                                  .add(LobChanged({"right": value}));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Value must not be null';
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

class TDropdown extends StatelessWidget {
  const TDropdown({
    required this.initialName,
    required this.initialDevices,
    super.key,
  });

  final String initialName;
  final List<Device> initialDevices;

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
      validator: (value) {
        if (value == null && initialName == 'Select device') {
          return 'Please select device';
        }
        return null;
      },
      onChanged: (value) {
        if (value != null) {
          context.read<TileEditBloc>().add(DeviceIdChanged(value));
        }
      },
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
    final textTheme = Theme.of(context).textTheme;
    final isEdit = context.select((TileEditBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((TileEditBloc bloc) => bloc.state.isAdmin);

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
                        context.read<TileEditBloc>().add(const Submitted());
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
                            .read<TileEditBloc>()
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
    final initialTile =
        context.select((TileEditBloc bloc) => bloc.state.initialTile);
    final isEdit = context.select((TileEditBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          initialTile == null
              ? 'New tile'
              : isEdit
                  ? 'Edit tile'
                  : 'Tile detail',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
      ],
    );
  }
}
