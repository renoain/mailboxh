// Kontrak repository fitur log.

import 'log_models.dart';

/// Kontrak akses data untuk pencatatan tontonan.
abstract class LogRepository {
  const LogRepository();

  /// Mencatat satu tontonan beserta rating, review, dan tag sekaligus.
  Future<void> submit(LogDraft draft);
}
