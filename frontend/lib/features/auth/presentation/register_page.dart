// Halaman pendaftaran yang terhubung ke endpoint auth backend.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/auth_field.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/providers/app_state.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/utils/validators.dart';
import '../../catalog/presentation/main_navigation.dart';
import '../domain/auth_models.dart';
import 'auth_layout.dart';
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
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;

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
    if (!_acceptTerms || !_acceptPrivacy) {
      return text.consentRequired;
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
    return AuthLayout(
      artwork: AppAssets.artworkJoin,
      film: AppStrings.artworkJoinFilm,
      heading: text.joinHeading,
      error: _error,
      form: Column(
        children: [
          AuthField(
            controller: _emailController,
            hint: text.email,
            keyboardType: TextInputType.emailAddress,
          ),
          AuthField(controller: _nameController, hint: text.username),
          AuthField(
            controller: _passwordController,
            hint: text.password,
            obscureText: true,
          ),
          AuthField(
            controller: _confirmController,
            hint: text.passwordConfirmation,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          AuthConsentRow(
            label: text.consentTerms,
            value: _acceptTerms,
            onChanged: (bool value) => setState(() => _acceptTerms = value),
          ),
          AuthConsentRow(
            label: text.consentPrivacy,
            value: _acceptPrivacy,
            onChanged: (bool value) => setState(() => _acceptPrivacy = value),
          ),
        ],
      ),
      actions: AuthActions(
        children: [
          AuthSmallButton(
            label: text.loginTitle,
            onPressed: () => Navigator.pop(context),
          ),
          AuthSmallButton(label: text.resetPassword, onPressed: null),
          AuthSmallButton(
            label: text.registerButton,
            filled: true,
            loading: _isLoading,
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
