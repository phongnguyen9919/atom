import 'package:atom/common/t_label_field.dart';
import 'package:atom/common/t_simply_text_field.dart';
import 'package:atom/common/t_snackbar.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/packages/models/models.dart';
import 'package:atom/broker_edit/bloc/broker_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BrokerEditView extends StatelessWidget {
  const BrokerEditView({
    super.key,
    required this.initialBroker,
  });

  final Broker? initialBroker;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // get padding top
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final isEdit = context.select((BrokerEditBloc bloc) => bloc.state.isEdit);

    return BlocListener<BrokerEditBloc, BrokerEditState>(
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
                  content: state.initialBroker == null
                      ? 'New Broker has been created'
                      : 'Broker has been updated',
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
                          initText: initialBroker?.name,
                          enabled: isEdit,
                          onChanged: (name) => context
                              .read<BrokerEditBloc>()
                              .add(NameChanged(name)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value must not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Url'),
                        TSimplyTextField(
                          initText: initialBroker?.url,
                          enabled: isEdit,
                          onChanged: (url) => context
                              .read<BrokerEditBloc>()
                              .add(UrlChanged(url)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value must not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Port'),
                        TSimplyTextField(
                          initText: initialBroker?.port.toString(),
                          enabled: isEdit,
                          textInputType: TextInputType.number,
                          onChanged: (port) => context
                              .read<BrokerEditBloc>()
                              .add(PortChanged(port)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value must not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Account'),
                        TSimplyTextField(
                          initText: initialBroker?.account,
                          enabled: isEdit,
                          onChanged: (account) => context
                              .read<BrokerEditBloc>()
                              .add(AccountChanged(account)),
                          validator: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        const TLabelField(title: 'Password'),
                        TSimplyTextField(
                          initText: initialBroker?.password,
                          enabled: isEdit,
                          onChanged: (password) => context
                              .read<BrokerEditBloc>()
                              .add(PasswordChanged(password)),
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

class _Header extends StatelessWidget {
  const _Header(this.formKey);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final isEdit = context.select((BrokerEditBloc bloc) => bloc.state.isEdit);
    final isAdmin = context.select((BrokerEditBloc bloc) => bloc.state.isAdmin);

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
                        context.read<BrokerEditBloc>().add(const Submitted());
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
                            .read<BrokerEditBloc>()
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
    final initialBroker =
        context.select((BrokerEditBloc bloc) => bloc.state.initialBroker);
    final isEdit = context.select((BrokerEditBloc bloc) => bloc.state.isEdit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          initialBroker == null
              ? 'New broker'
              : isEdit
                  ? 'Edit broker'
                  : 'Broker detail',
          style: textTheme.headlineSmall!.copyWith(color: ColorName.darkWhite),
        ),
      ],
    );
  }
}
