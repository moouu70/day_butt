import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/background_slot.dart';
import '../models/effective_theme.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';
import '../models/user_theme_overrides.dart';

class ThemeResolver {
  static EffectiveTheme resolve({
    required AppThemePreset preset,
    required UserThemeOverrides overrides,
  }) {
    // 1. Resolve Colors
    ThemeColors colors = preset.colors;
    if (overrides.customAccent != null) {
      final accent = overrides.customAccent!;
      final hsl = HSLColor.fromColor(accent);
      // Create a harmonious secondary color with slight lightness/hue adjustment
      final secondaryHsl = hsl.withLightness((hsl.lightness + 0.15).clamp(0.0, 0.95));
      final secondaryColor = secondaryHsl.toColor();

      colors = colors.copyWith(
        primary: accent,
        secondary: secondaryColor,
        accentGlow: accent.withOpacity(0.35),
      );
    }

    // 2. Resolve Glass
    var glass = preset.glass;
    if (overrides.glassIntensity != null) {
      glass = glass.applyIntensity(overrides.glassIntensity!);
    }
    if (overrides.blurIntensity != null) {
      glass = glass.applyBlur(overrides.blurIntensity!);
    }

    // 3. Resolve Glow
    var glow = preset.glow;
    if (overrides.glowIntensity != null) {
      glow = glow.applyIntensity(overrides.glowIntensity!);
    }

    // 4. Resolve Background Mode
    final mode = overrides.backgroundMode ?? preset.defaultBackgroundMode;
    final showBg = mode != BackgroundMode.none &&
        mode != BackgroundMode.solid &&
        preset.showBackgroundImage;

    // 5. Resolve Per-Slot Backgrounds
    ThemeBackgrounds backgrounds = preset.backgrounds;
    if (overrides.slotBackgrounds.isNotEmpty) {
      final map = overrides.slotBackgrounds;
      backgrounds = backgrounds.copyWith(
        home: map[BackgroundSlot.home],
        university: map[BackgroundSlot.university],
        calories: map[BackgroundSlot.calories],
        expenses: map[BackgroundSlot.expenses],
        routine: map[BackgroundSlot.routine],
        notes: map[BackgroundSlot.notes],
        settings: map[BackgroundSlot.settings],
      );
    }

    // 6. Return EffectiveTheme
    return EffectiveTheme(
      basePreset: preset,
      colors: colors,
      glass: glass,
      glow: glow,
      backgrounds: backgrounds,
      backgroundMode: mode,
      showBackgroundImage: showBg,
      overlayOpacity: preset.defaultOverlayOpacity,
      customSlotImages: overrides.customSlotImages,
    );
  }
}
