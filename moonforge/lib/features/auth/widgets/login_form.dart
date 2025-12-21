import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _localError;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _emailController.text = widget.initialEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoginForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialEmail != null &&
        widget.initialEmail != oldWidget.initialEmail &&
        _emailController.text != widget.initialEmail) {
      _emailController.text = widget.initialEmail!;
      _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: _emailController.text.length),
      );
    }
  }

  String? _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      return 'Email is required.';
    }
    if (!email.contains('@')) {
      return 'Enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Password is required.';
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

    await ref
        .read(authProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);
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
          Text('Adventurer Email').small().semiBold(),
          Gap(AppSpacing.sm),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            placeholder: const Text('Gandalf@shire.com'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Secret Phrase').small().semiBold(),
              LinkButton(
                onPressed: isBusy ? null : () {},
                child: const Text('Forgot phrase?'),
              ),
            ],
          ),
          Gap(AppSpacing.sm),
          TextField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            obscureText: true,
            placeholder: const Text('••••••••'),
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
            child: const Padding(
              padding: AppSpacing.paddingXs,
              child: Text('Open the Gate'),
            ),
          ),
        ],
      ),
    );
  }
}
