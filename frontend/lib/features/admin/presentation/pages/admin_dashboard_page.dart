// Halaman dashboard admin: ringkasan statistik dan aksi cepat.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../admin_provider.dart';

/// Menampilkan total film, user, review serta tombol aksi cepat.
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppText text = AppStrings.id;
    final AdminState state = ref.watch(adminProvider);

    return Scaffold(
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  text.adminDashboard,
                  style: AppTypography.headlineLg,
                ),
                const SizedBox(height: AppSpacing.lg),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 2,
                  children: [
                    _StatCard(
                      title: 'Total Film',
                      value: '${state.dashboard?.totalMovies ?? 0}',
                      color: Colors.blue,
                    ),
                    _StatCard(
                      title: 'Total User',
                      value: '${state.dashboard?.totalUsers ?? 0}',
                      color: Colors.green,
                    ),
                    _StatCard(
                      title: 'Total Review',
                      value: '${state.dashboard?.totalReviews ?? 0}',
                      color: Colors.orange,
                    ),
                  ],
                ),
                if (state.error != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    state.error!.message,
                    style: AppTypography.bodyMd.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Aksi Cepat',
                  style: AppTypography.headlineMd,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Film'),
                    onPressed: state.isLoading
                        ? null
                        : () {
                            Navigator.pushNamed(
                                context, '/admin/movies/form');
                          },
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Impor Batch'),
                    onPressed: state.importLoading
                        ? null
                        : () {
                            Navigator.pushNamed(
                                context, '/admin/batch-import');
                          },
                  ),
                ),
              ],
            ),
    );
  }
}

/// Kartu statistik dengan judul dan nilai.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTypography.headlineLg.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTypography.bodySm.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
