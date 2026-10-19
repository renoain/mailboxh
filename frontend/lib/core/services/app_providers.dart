// Provider bersama untuk seluruh aplikasi.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/token_storage.dart';

/// Data sesi singkat yang mencakup status login dan role admin.
class SessionData {
  const SessionData({
    required this.hasToken,
    required this.isAdmin,
  });

  final bool hasToken;
  final bool isAdmin;
}

/// Penyimpanan token sesi. Di-override pada test.
final Provider<TokenStorage> tokenStorageProvider = Provider<TokenStorage>(
  (Ref ref) => TokenStorage(),
);

/// Klien HTTP tunggal. Di-override pada test.
final Provider<ApiClient> apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(tokenStorage: ref.watch(tokenStorageProvider)),
);

/// Status sesi. Splash membacanya lalu mengarahkan route.
final AsyncNotifierProvider<SessionNotifier, SessionData> sessionProvider =
    AsyncNotifierProvider<SessionNotifier, SessionData>(SessionNotifier.new);

/// Menyimpan apakah user sudah login dan memeriksa token serta role saat
/// aplikasi dibuka.
class SessionNotifier extends AsyncNotifier<SessionData> {
  @override
  Future<SessionData> build() async {
    final TokenStorage storage = ref.watch(tokenStorageProvider);
    final hasToken = await storage.hasToken();
    final isAdmin = hasToken ? await storage.isAdmin() : false;
    return SessionData(hasToken: hasToken, isAdmin: isAdmin);
  }

  Future<void> signIn({bool isAdmin = false}) async {
    state = const AsyncValue<SessionData>.data(
      SessionData(hasToken: true, isAdmin: isAdmin),
    );
  }

  Future<void> signOut() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncValue<SessionData>.data(
      SessionData(hasToken: false, isAdmin: false),
    );
  }
}
