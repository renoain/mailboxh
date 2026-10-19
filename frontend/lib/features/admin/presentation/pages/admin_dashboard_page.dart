// Halaman dashboard admin dengan ringkasan statistik.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/admin_model.dart';
import '../admin_provider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminNotifierProvider);
    final text = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(adminNotifierProvider.notifier).loadDashboard();
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
        onRetry: () => ref.read(adminNotifierProvider.notifier).loadDashboard(),
      );
    }

    final summary = state.data as DashboardSummary?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Ringkasan Data',
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  context,
                  'Total Film',
                  summary?.totalMovies.toString() ?? '-',
                  Icons.movie_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _statCard(
                  context,
                  'Total User',
                  summary?.totalUsers.toString() ?? '-',
                  Icons.person_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _statCard(
                  context,
                  'Total Review',
                  summary?.totalReviews.toString() ?? '-',
                  Icons.rate_review_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Aksi Cepat',
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Tambah Film',
            onPressed: () => context.pushNamed(AppRoutes.adminMovieForm),
            variant: AppButtonVariant.primary,
            icon: Icons.add,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Batch Import (ZIP)',
            onPressed: () => context.pushNamed(AppRoutes.adminBatchImport),
            variant: AppButtonVariant.secondary,
            icon: Icons.file_upload,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: AppSpacing.twoXl),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTypography.headlineLg.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodyMd.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

extension _LanguageCode on BuildContext {
  String get languageCode => Localizations.localeOf(this).languageCode;
}
