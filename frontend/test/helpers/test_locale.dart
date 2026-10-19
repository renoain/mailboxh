// Inisialisasi data locale intl untuk widget test.

import 'package:intl/date_symbol_data_local.dart';
import 'package:mailboxh/core/utils/formatters.dart';

/// Memuat simbol tanggal locale yang dipakai [AppFormatters].
Future<void> initializeTestLocale() async {
  await initializeDateFormatting(AppFormatters.localeId);
  await initializeDateFormatting(AppFormatters.localeEn);
}
