// Penyimpanan penanda pemakaian pertama aplikasi.

import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan flag nonrahasia onboarding lewat SharedPreferences.
class OnboardingStorage {
  const OnboardingStorage();

  static const String _seenKey = 'has_seen_onboarding';

  Future<bool> hasSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }

  Future<void> markSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }
}
