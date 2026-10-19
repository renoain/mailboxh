// Halaman masuk yang terhubung ke endpoint auth backend.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/providers/app_state.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../admin/presentation/admin_layout.dart';
import '../../admin/presentation/pages/admin_dashboard_page.dart';
import '../../catalog/presentation/main_navigation.dart';
import '../domain/auth_models.dart';
import 'auth_provider.dart';
import 'register_page.dart';

/// Form masuk dengan email dan kata sandi.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static const AppText text = AppStrings.id;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _error;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('saved_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailController.text = savedEmail;
      setState(() => _rememberMe = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validate() {
    if (!AppValidators.isRequired(_emailController.text)) {
      return text.fieldRequired;
    }
    if (!AppValidators.isEmail(_emailController.text)) {
      return text.invalidEmail;
    }
    if (!AppValidators.isPasswordValid(_passwordController.text)) {
      return text.passwordTooShort;
    }
    return null;
  }

  Future<void> _submit() async {
    final String? validationError = _validate();
    if (validationError != null) {
      setState(() => _error = validationError);
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text.trim());
    } else {
      await prefs.remove('saved_email');
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });
    try {
      final AuthUser user = await ref.read(authProvider.notifier).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      await ref.read(sessionProvider.notifier).signIn();
      if (!mounted) return;
      // Kompatibilitas sementara dengan halaman lama berbasis AppState.
      final AppState appState = Provider.of<AppState>(context, listen: false);
      appState.login();
      appState.updateProfile(user.name, user.email);
      if (user.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminLayout(child: const AdminDashboardPage()),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } on AppException catch (error) {
      if (!mounted) return;
      if (error is UnauthorizedException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.invalidCredentials)),
        );
      }
      setState(() {
        _error = error is UnauthorizedException
            ? text.invalidCredentials
            : error.message;
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
        title: Text(text.loginTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text.loginTitle, style: AppTypography.headlineLg),
              const SizedBox(height: AppSpacing.lg),
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
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(labelText: text.password),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                  ),
                  Text(text.rememberMe),
                ],
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
                      : Text(text.loginButton),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: Text(text.noAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
