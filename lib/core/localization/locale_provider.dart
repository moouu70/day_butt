import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLanguageKey = 'selected_app_language';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadSavedLocale();
    return const Locale('en');
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_kLanguageKey);
      if (code != null && (code == 'en' || code == 'ar')) {
        state = Locale(code);
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale newLocale) async {
    if (state.languageCode == newLocale.languageCode) return;
    state = newLocale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguageKey, newLocale.languageCode);
    } catch (_) {}
  }

  Future<void> toggleLanguage() async {
    final next = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    await setLocale(next);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
