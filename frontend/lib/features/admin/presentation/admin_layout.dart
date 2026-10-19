// Layout admin dengan drawer navigasi dan guard role admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/auth_provider.dart';
import '../../auth/domain/auth_models.dart';

/// Layout admin dengan drawer navigasi. Hanya bisa diakses oleh role admin.
class AdminLayout extends ConsumerWidget {
  const AdminLayout({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthUser?> auth = ref.watch(authProvider);
    final bool isAdmin = auth.value?.isAdmin ?? false;

    if (!isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text('Akses ditolak. Hanya admin.'),
        ),
      );
    }

    return Scaffold(
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
              selected: true,
              onTap: () => context.pop(),
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
      body: child,
    );
  }
}
