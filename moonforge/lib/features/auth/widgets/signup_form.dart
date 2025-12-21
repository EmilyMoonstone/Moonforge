import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key, this.onSignedUp});

  final ValueChanged<String>? onSignedUp;

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validate() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty) {
      return 'Username is required.';
    }
    if (email.isEmpty) {
      return 'Email is required.';
    }
    if (!email.contains('@')) {
      return 'Enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _localError = _validate();
    });

    if (_localError != null) {
      return;
    }

    await ref.read(authProvider.notifier).signup(
          _emailController.text.trim(),
          _passwordController.text,
          username: _usernameController.text.trim(),
        );
    final error = ref.read(authProvider).error;
    if (error == null) {
      setState(() {
        _localError = null;
      });
      widget.onSignedUp?.call(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isBusy = authState.isBusy;
    final errorText = _localError ?? authState.error;

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Username').small().semiBold(),
          Gap(AppSpacing.sm),
          TextField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            placeholder: const Text('Your adventurer name'),
            enabled: !isBusy,
            features: [
              InputFeature.leading(Icon(Icons.person_outline)),
            ],
            onChanged: (_) {
              if (_localError != null) {
                setState(() {
                  _localError = null;
                });
              }
            },
          ),
          Gap(AppSpacing.lg),
          Text('Email').small().semiBold(),
          Gap(AppSpacing.sm),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            placeholder: const Text('you@moonforge.app'),
            enabled: !isBusy,
            features: [InputFeature.leading(Icon(Icons.mail_outline))],
            onChanged: (_) {
              if (_localError != null) {
                setState(() {
                  _localError = null;
                });
              }
            },
          ),
          Gap(AppSpacing.lg),
          Text('Choose a Secret Phrase').small().semiBold(),
          Gap(AppSpacing.sm),
          TextField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            obscureText: true,
            placeholder: const Text('Create a strong password'),
            enabled: !isBusy,
            features: [
              InputFeature.leading(Icon(Icons.lock_outline)),
              InputFeature.passwordToggle(),
            ],
            onSubmitted: (_) => _submit(),
            onChanged: (_) {
              if (_localError != null) {
                setState(() {
                  _localError = null;
                });
              }
            },
          ),
          if (errorText != null) ...[
            Gap(AppSpacing.md),
            Text(
              errorText,
              style: theme.typography.small.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ],
          Gap(AppSpacing.lg),
          PrimaryButton(
            onPressed: isBusy ? null : _submit,
            leading: isBusy
                ? const CircularProgressIndicator(
                    size: 16,
                    strokeWidth: 2,
                    onSurface: true,
                  )
                : null,
            enabled: !isBusy,
            child: const Padding(
              padding: AppSpacing.paddingXs,
              child: Text('Create Account'),
            ),
          ),
        ],
      ),
    );
  }
}
