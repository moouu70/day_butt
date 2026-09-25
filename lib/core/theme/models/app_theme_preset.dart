import 'package:flutter/material.dart';
import 'background_mode.dart';
import 'glass_settings.dart';
import 'glow_settings.dart';
import 'theme_backgrounds.dart';
import 'theme_colors.dart';

class AppThemePreset {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;

  final ThemeColors colors;
  final GlassSettings glass;
  final GlowSettings glow;
  final ThemeBackgrounds backgrounds;

  final BackgroundMode defaultBackgroundMode;
  final bool showBackgroundImage;
  final double defaultOverlayOpacity;
  final Gradient previewGradient;

  const AppThemePreset({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.colors,
    required this.glass,
    required this.glow,
    required this.backgrounds,
    this.defaultBackgroundMode = BackgroundMode.imageWithOverlay,
    this.showBackgroundImage = true,
    this.defaultOverlayOpacity = 0.78,
    required this.previewGradient,
  });

  String getName(bool isArabic) => isArabic ? nameAr : name;
  String getDescription(bool isArabic) => isArabic ? descriptionAr : description;
}
