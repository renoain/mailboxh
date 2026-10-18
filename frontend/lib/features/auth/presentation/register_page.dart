// Halaman pendaftaran yang terhubung ke endpoint auth backend.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/providers/app_state.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../catalog/presentation/main_navigation.dart';
import '../domain/auth_models.dart';
import 'auth_provider.dart';

/// Form pendaftaran user baru; sukses berarti langsung masuk.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  static const AppText text = AppStrings.id;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validate() {
    if (!AppValidators.isRequired(_nameController.text)) {
      return text.fieldRequired;
    }
    if (!AppValidators.isEmail(_emailController.text)) {
      return text.invalidEmail;
    }
    if (!AppValidators.isPasswordValid(_passwordController.text)) {
      return text.passwordTooShort;
    }
    if (_passwordController.text != _confirmController.text) {
      return text.passwordConfirmation;
    }
    return null;
  }

  Future<void> _submit() async {
    final String? validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    setState(() {
      _error = null;
      _isLoading = true;
    });
    try {
      final AuthUser user = await ref.read(authProvider.notifier).signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      await ref.read(sessionProvider.notifier).signIn();
      if (!mounted) return;
      // Kompatibilitas sementara dengan halaman lama berbasis AppState.
      final AppState appState = Provider.of<AppState>(context, listen: false);
      appState.login();
      appState.updateProfile(user.name, user.email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = text.somethingWrong;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(text.registerTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text.registerTitle, style: AppTypography.headlineLg),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: text.name),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: text.email),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: text.password),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _confirmController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration:
                    InputDecoration(labelText: text.passwordConfirmation),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _error!,
                  style: AppTypography.bodyMd.copyWith(color: colors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: AppSpacing.md,
                          width: AppSpacing.md,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(text.registerButton),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(text.haveAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
