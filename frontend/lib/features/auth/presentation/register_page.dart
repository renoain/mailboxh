// Halaman registrasi user baru.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../presentation/auth_provider.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(text.registerTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _RegisterForm(
                authState: authState,
                text: text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm({
    required this.authState,
    required this.text,
  });

  final AuthState authState;
  final AppText text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text.registerTitle,
          style: AppTypography.headlineMd,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (authState.error != null) ...[
          AppErrorState(
            message: authState.error!.message,
            onRetry: () =>
                ref.read(authNotifierProvider.notifier).clearError(),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        CustomTextField(
          label: text.name,
          controller: nameController,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: text.email,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: text.password,
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: text.registerButton,
          isLoading: authState.isLoading,
          onPressed: authState.isLoading
              ? null
              : () async {
                  await ref.read(authNotifierProvider.notifier).register(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  final authState = ref.read(authNotifierProvider);
                  if (authState.isAuthenticated && authState.user != null) {
                    ref.read(sessionProvider.notifier).signIn(
                      isAdmin: authState.user!.role == 'admin',
                    );
                  }
                },
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text.haveAccount, style: AppTypography.bodyMd),
            const SizedBox(width: AppSpacing.xs),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(text.loginTitle),
            ),
          ],
        ),
      ],
    );
  }
}
