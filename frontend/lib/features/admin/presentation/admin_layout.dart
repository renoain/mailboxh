// Layout admin dengan drawer navigasi dan guard role admin.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/domain/auth_models.dart';

/// Layout admin dengan drawer navigasi. Hanya bisa diakses oleh role admin.
class AdminLayout extends ConsumerStatefulWidget {
  const AdminLayout({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends ConsumerState<AdminLayout> {
  static const AppText text = AppStrings.id;

  bool _backPressedOnce = false;
  Timer? _backTimer;

  @override
  void dispose() {
    _backTimer?.cancel();
    super.dispose();
  }

  bool get _isHome {
    return GoRouter.maybeOf(context)?.state.matchedLocation ==
        '/admin/dashboard';
  }

  void _handleBack() {
    if (_backPressedOnce) {
      _backTimer?.cancel();
      _backPressedOnce = false;
      context.go('/home');
      return;
    }
    _backPressedOnce = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text.backToUserPage)),
    );
    _backTimer = Timer(const Duration(seconds: 2), () {
      _backPressedOnce = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthUser?> auth = ref.watch(authProvider);
    final bool isAdmin = auth.value?.isAdmin ?? false;

    if (!isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text('Akses ditolak. Hanya admin.'),
        ),
      );
    }

    return PopScope(
      canPop: !_isHome,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop || !_isHome) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mailboxh Admin'),
          automaticallyImplyLeading: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: const Text(
                  'Menu Admin',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => context.go('/admin/dashboard'),
              ),
              ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('Film'),
                onTap: () => context.push('/admin/movies'),
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Genre'),
                onTap: () => context.push('/admin/genres'),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('User'),
                onTap: () => context.push('/admin/users'),
              ),
              ListTile(
                leading: const Icon(Icons.reviews),
                title: const Text('Review'),
                onTap: () => context.push('/admin/reviews'),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('Impor Batch'),
                onTap: () => context.push('/admin/batch-import'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Lihat sebagai User'),
                onTap: () => context.go('/home'),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Keluar'),
                onTap: () async {
                  await ref.read(authProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          ),
        ),
        body: widget.child,
      ),
    );
  }
}