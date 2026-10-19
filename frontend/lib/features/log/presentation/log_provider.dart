// State form log tontonan.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/log_repository.dart';
import '../domain/log_models.dart';

/// Mengirim form log dan menyimpan status pengirimannya.
class LogFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Mengirim [draft]. Mengembalikan true bila berhasil.
  Future<bool> submit(LogDraft draft) async {
    state = const AsyncLoading<void>();
    try {
      await ref.read(logRepositoryProvider).submit(draft);
      state = const AsyncData<void>(null);
      return true;
    } on AppException catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return false;
    } catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return false;
    }
  }
}

/// Provider form log tontonan.
final AsyncNotifierProvider<LogFormController, void> logFormProvider =
    AsyncNotifierProvider<LogFormController, void>(LogFormController.new);
