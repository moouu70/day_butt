import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/background_slot.dart';
import '../models/effective_theme.dart';
import '../models/user_theme_overrides.dart';
import '../presets/app_presets.dart';
import '../resolver/theme_resolver.dart';

class ThemeState {
  final AppThemePreset preset;
  final UserThemeOverrides overrides;
  final EffectiveTheme effectiveTheme;

  const ThemeState({
    required this.preset,
    required this.overrides,
    required this.effectiveTheme,
  });

  factory ThemeState.initial() {
    final defaultPreset = midnightTheme;
    final defaultOverrides = UserThemeOverrides.empty;
    final effective = ThemeResolver.resolve(
      preset: defaultPreset,
      overrides: defaultOverrides,
    );
    return ThemeState(
      preset: defaultPreset,
      overrides: defaultOverrides,
      effectiveTheme: effective,
    );
  }

  ThemeState copyWith({
    AppThemePreset? preset,
    UserThemeOverrides? overrides,
  }) {
    final nextPreset = preset ?? this.preset;
    final nextOverrides = overrides ?? this.overrides;
    final nextEffective = ThemeResolver.resolve(
      preset: nextPreset,
      overrides: nextOverrides,
    );
    return ThemeState(
      preset: nextPreset,
      overrides: nextOverrides,
      effectiveTheme: nextEffective,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  static const String _storageKey = 'day_butt_theme_settings';

  @override
  ThemeState build() {
    _loadFromPrefs();
    return ThemeState.initial();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        final presetId = data['presetId'] as String? ?? 'midnight';
        final preset = findPresetById(presetId);
        final overrides = UserThemeOverrides.fromJson(data);
        final effective = ThemeResolver.resolve(
          preset: preset,
          overrides: overrides,
        );
        state = ThemeState(
          preset: preset,
          overrides: overrides,
          effectiveTheme: effective,
        );
      }
    } catch (_) {
      // Fallback gracefully to default theme
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = state.overrides.toJson();
      map['presetId'] = state.preset.id;
      await prefs.setString(_storageKey, jsonEncode(map));
    } catch (_) {}
  }

  void setPreset(AppThemePreset newPreset) {
    state = state.copyWith(preset: newPreset);
    _saveToPrefs();
  }

  void setAccentColor(Color? color) {
    final newOverrides = state.overrides.copyWith(
      customAccent: color,
      clearCustomAccent: color == null,
    );
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void setGlassIntensity(VisualIntensity? intensity) {
    final newOverrides = state.overrides.copyWith(glassIntensity: intensity);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void setBlurIntensity(VisualIntensity? intensity) {
    final newOverrides = state.overrides.copyWith(blurIntensity: intensity);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void setGlowIntensity(VisualIntensity? intensity) {
    final newOverrides = state.overrides.copyWith(glowIntensity: intensity);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void setBackgroundMode(BackgroundMode? mode) {
    final newOverrides = state.overrides.copyWith(backgroundMode: mode);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void setSlotBackground(BackgroundSlot slot, String pathOrAsset) {
    final current = Map<BackgroundSlot, String>.from(state.overrides.slotBackgrounds);
    current[slot] = pathOrAsset;
    final newOverrides = state.overrides.copyWith(slotBackgrounds: current);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void setCustomSlotImage(BackgroundSlot slot, String filePath) {
    final current = Map<BackgroundSlot, String>.from(state.overrides.customSlotImages);
    current[slot] = filePath;
    final newOverrides = state.overrides.copyWith(customSlotImages: current);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void removeCustomSlotImage(BackgroundSlot slot) {
    final current = Map<BackgroundSlot, String>.from(state.overrides.customSlotImages);
    current.remove(slot);
    final newOverrides = state.overrides.copyWith(customSlotImages: current);
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  void clearAllCustomSlotImages() {
    final newOverrides = state.overrides.copyWith(customSlotImages: {});
    state = state.copyWith(overrides: newOverrides);
    _saveToPrefs();
  }

  Future<void> resetToDefaults() async {
    final defaultPreset = midnightTheme;
    final defaultOverrides = UserThemeOverrides.empty;
    state = ThemeState(
      preset: defaultPreset,
      overrides: defaultOverrides,
      effectiveTheme: ThemeResolver.resolve(
        preset: defaultPreset,
        overrides: defaultOverrides,
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(() {
  return ThemeNotifier();
});

final effectiveThemeProvider = Provider<EffectiveTheme>((ref) {
  return ref.watch(themeProvider).effectiveTheme;
});
