// Halaman daftar user untuk admin.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/admin_model.dart';
import '../admin_provider.dart';

class AdminUsersPage extends ConsumerWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola User')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(adminNotifierProvider.notifier).loadUsers();
        },
        child: _buildBody(context, ref, state, text),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AdminState state,
    AppText text,
  ) {
    if (state.isLoading && state.data == null) {
      return const LoadingIndicator(isFullScreen: true);
    }

    if (state.error != null && state.data == null) {
      return AppErrorState(
        message: state.error!.message,
        onRetry: () => ref.read(adminNotifierProvider.notifier).loadUsers(),
      );
    }

    final users = state.data as List<AdminUser>? ?? [];

    if (users.isEmpty) {
      return const Center(child: Text('Belum ada user.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _UserItem(
          user: user,
          onRoleChanged: (role) =>
              ref.read(adminNotifierProvider.notifier).updateUserRole(
                user.id,
                role,
              ),
        );
      },
    );
  }
}

class _UserItem extends ConsumerWidget {
  const _UserItem({
    required this.user,
    required this.onRoleChanged,
  });

  final AdminUser user;
  final ValueChanged<String> onRoleChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        title: Text(
          user.name,
          style: AppTypography.labelLg.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(
              user.email,
              style: AppTypography.bodySm.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: DropdownButton<String>(
          value: user.role,
          items: const [
            DropdownMenuItem(value: 'user', child: Text('User')),
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
          ],
          onChanged: (value) {
            if (value != null) onRoleChanged(value);
          },
        ),
      ),
    );
  }
}
