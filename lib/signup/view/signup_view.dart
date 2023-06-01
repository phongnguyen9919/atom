import 'package:atom/common/t_fill_button.dart';
import 'package:atom/common/t_label_field.dart';
import 'package:atom/common/t_simply_password_field.dart';
import 'package:atom/common/t_simply_text_field.dart';
import 'package:atom/common/t_snackbar.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/login/view/login_page.dart';
import 'package:atom/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // use ListView to make page scroll up when keyboard comes
    if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isWaiting()) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
          if (state.status.isSuccess()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.success(context,
                    content: 'Domain has created successfully!'),
              );
            Navigator.of(context)
                .pushAndRemoveUntil(LoginPage.route(), (route) => false);
          } else if (state.status.isFailure()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                TSnackbar.error(context, content: state.error!),
              );
          }
        }
      },
      child: GestureDetector(
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 32,
            ),
            children: [
              const _Header(),
              const SizedBox(height: 32),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TLabelField(title: 'Domain'),
                    TSimplyTextField(
                      initText: null,
                      onChanged: (domainName) {
                        context
                            .read<SignupBloc>()
                            .add(DomainNameChanged(domainName));
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Value must not be null';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const TLabelField(title: 'Username'),
                    TSimplyTextField(
                      initText: null,
                      // picture: Assets.icons.frame,
                      onChanged: (username) => context
                          .read<SignupBloc>()
                          .add(UsernameChanged(username)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Value must not be null';
                        }
                        return null;
                      },
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    const TLabelField(title: 'Password'),
                    TSimplyPasswordField(
                      initText: null,
                      // picture: Assets.icons.key,
                      onChanged: (password) => context
                          .read<SignupBloc>()
                          .add(PasswordChanged(password)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Value must not be null';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 48),
              TFillButton(
                  onPressed: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      context.read<SignupBloc>().add(const Submitted());
                    }
                  },
                  title: 'SIGN UP'),
              const SizedBox(height: 16),
              const _LinkText(),
              const SizedBox(height: 128),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: RichText(
        text: TextSpan(
          style: textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorName.XBlack,
          ),
          children: [
            const TextSpan(
              text: "Have an account? ",
            ),
            WidgetSpan(
              baseline: TextBaseline.alphabetic,
              alignment: PlaceholderAlignment.baseline,
              child: InkWell(
                onTap: () => Navigator.of(context)
                    .pushAndRemoveUntil(LoginPage.route(), (route) => false),
                child: Text(
                  'Sign In Now',
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorName.XRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'SIGN UP',
            style: textTheme.headlineMedium!.copyWith(
              color: ColorName.XBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
