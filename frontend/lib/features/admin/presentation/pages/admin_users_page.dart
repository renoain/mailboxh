// Halaman kelola user admin dengan perubahan role.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../admin_provider.dart';
import '../../domain/admin_models.dart';

/// Menampilkan daftar user dengan dropdown ubah role.
class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AdminState state = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola User')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.users.isEmpty
              ? const Center(child: Text('Belum ada user.'))
              : ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AdminUser user = state.users[index];
                    return _UserItem(user: user);
                  },
                ),
    );
  }
}

/// Item user dengan dropdown role.
class _UserItem extends ConsumerWidget {
  const _UserItem({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: DropdownButton<String>(
          value: user.role,
          items: const [
            DropdownMenuItem(value: 'user', child: Text('User')),
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
          ],
          onChanged: (String? newRole) {
            if (newRole != null && newRole != user.role) {
              ref.read(adminProvider.notifier).updateUserRole(
                    id: user.id,
                    role: newRole,
                  );
            }
          },
        ),
      ),
    );
  }
}
