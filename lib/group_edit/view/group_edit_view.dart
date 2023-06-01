import 'package:atom/common/t_label_field.dart';
import 'package:atom/common/t_simply_text_field.dart';
import 'package:atom/common/t_snackbar.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/group_edit/bloc/group_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class GroupEditView extends StatelessWidget {
  const GroupEditView({
    super.key,
    required this.initialName,
  });

  final String? initialName;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final isEdit = context.select((GroupEditBloc bloc) => bloc.state.isEdit);

    return BlocListener<GroupEditBloc, GroupEditState>(
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
                      ? 'New Group has been created'
                      : 'Group has been updated',
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
                        const TLabelField(title: 'Username'),
                        TSimplyTextField(
                          initText: initialName,
                          enabled: isEdit,
                          onChanged: (username) => context
                              .read<GroupEditBloc>()
                              .add(NameChanged(username)),
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

class _Header extends StatelessWidget {
  const _Header(this.formKey);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEdit = context.select((GroupEditBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((GroupEditBloc bloc) => bloc.state.isAdmin);

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
                        context.read<GroupEditBloc>().add(const Submitted());
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
                            .read<GroupEditBloc>()
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
        context.select((GroupEditBloc bloc) => bloc.state.initialId);
    final isEdit = context.select((GroupEditBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          initialId == null
              ? 'New group'
              : isEdit
                  ? 'Edit group'
                  : 'Group detail',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
      ],
    );
  }
}
