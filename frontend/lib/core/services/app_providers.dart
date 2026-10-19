// Provider bersama untuk seluruh aplikasi.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/onboarding_storage.dart';
import '../services/token_storage.dart';

/// Penyimpanan token sesi. Di-override pada test.
final Provider<TokenStorage> tokenStorageProvider = Provider<TokenStorage>(
  (Ref ref) => TokenStorage(),
);

/// Penanda pemakaian pertama. Di-override pada test.
final Provider<OnboardingStorage> onboardingStorageProvider =
    Provider<OnboardingStorage>((Ref ref) => const OnboardingStorage());

/// Klien HTTP tunggal. Di-override pada test.
final Provider<ApiClient> apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(tokenStorage: ref.watch(tokenStorageProvider)),
);

/// Status sesi. Splash membacanya lalu mengarahkan route.
final AsyncNotifierProvider<SessionNotifier, bool> sessionProvider =
    AsyncNotifierProvider<SessionNotifier, bool>(SessionNotifier.new);

/// Menyimpan apakah user sudah login dan memeriksa token saat aplikasi
/// dibuka.
class SessionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final TokenStorage storage = ref.watch(tokenStorageProvider);
    return storage.hasToken();
  }

  Future<void> signIn() async {
    state = const AsyncValue<bool>.data(true);
  }

  Future<void> signOut() async {
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncValue<bool>.data(false);
  }
}