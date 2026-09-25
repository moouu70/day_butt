import 'dart:io';
import 'package:flutter/foundation.dart';
import 'app_theme_preset.dart';
import 'background_mode.dart';
import 'background_slot.dart';
import 'glass_settings.dart';
import 'glow_settings.dart';
import 'theme_backgrounds.dart';
import 'theme_colors.dart';

class EffectiveTheme {
  final AppThemePreset basePreset;
  final ThemeColors colors;
  final GlassSettings glass;
  final GlowSettings glow;
  final ThemeBackgrounds backgrounds;
  final BackgroundMode backgroundMode;
  final bool showBackgroundImage;
  final double overlayOpacity;
  final Map<BackgroundSlot, String> customSlotImages;

  const EffectiveTheme({
    required this.basePreset,
    required this.colors,
    required this.glass,
    required this.glow,
    required this.backgrounds,
    required this.backgroundMode,
    required this.showBackgroundImage,
    required this.overlayOpacity,
    required this.customSlotImages,
  });

  String get id => basePreset.id;
  String get name => basePreset.name;

  String? getEffectiveBackground(BackgroundSlot slot) {
    final customPath = customSlotImages[slot];
    if (customPath != null && customPath.isNotEmpty) {
      if (!kIsWeb) {
        try {
          if (File(customPath).existsSync()) {
            return customPath;
          }
        } catch (_) {}
      } else {
        return customPath;
      }
    }
    return backgrounds.forSlot(slot);
  }

  bool isCustomImage(BackgroundSlot slot) {
    final customPath = customSlotImages[slot];
    if (customPath == null || customPath.isEmpty) return false;
    if (!kIsWeb) {
      try {
        return File(customPath).existsSync();
      } catch (_) {
        return false;
      }
    }
    return true;
  }
}
