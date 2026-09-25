import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/glass_settings.dart';
import '../models/glow_settings.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';

const deepOceanTheme = AppThemePreset(
  id: 'deep_ocean',
  name: 'Deep Ocean',
  nameAr: 'أعماق المحيط',
  description: 'Abyssal midnight waters with cyan, deep blue, and aqua bioluminescence',
  descriptionAr: 'أعماق المحيط الهادئة مع إضاءات زرقاء وسماوية متوهجة',
  colors: ThemeColors(
    background: Color(0xFF060B14),
    backgroundDeep: Color(0xFF03060C),
    surface: Color(0xFF0D1626),
    surfaceSecondary: Color(0xFF132035),
    surfaceElevated: Color(0xFF182A45),
    primary: Color(0xFF13D7F2), // Cyan
    secondary: Color(0xFF286AA8), // Deep blue
    highlight: Color(0xFF5CEBFF), // Aqua
    accentCyan: Color(0xFF5CEBFF),
    accentGlow: Color(0x3313D7F2),
    textPrimary: Color(0xFFF0FDF4),
    textSecondary: Color(0xFF8DA4BE),
    textMuted: Color(0xFF566E87),
    success: Color(0xFF2DD4BF),
    successGlow: Color(0x332DD4BF),
    warning: Color(0xFFFBBF24),
    warningGlow: Color(0x33FBBF24),
    danger: Color(0xFFF43F5E),
    dangerGlow: Color(0x33F43F5E),
    info: Color(0xFF38BDF8),
    infoGlow: Color(0x3338BDF8),
    border: Color(0x2213D7F2),
    borderHighlight: Color(0x4013D7F2),
    catFood: Color(0xFFF43F5E),
    catTransport: Color(0xFF2DD4BF),
    catUniversity: Color(0xFF286AA8),
    catShopping: Color(0xFF13D7F2),
    catBills: Color(0xFFFBBF24),
    catOther: Color(0xFF5CEBFF),
    caloriesAccent: Color(0xFFF43F5E),
    expensesAccent: Color(0xFF286AA8),
    routineAccent: Color(0xFF2DD4BF),
    todoAccent: Color(0xFF13D7F2),
    notesAccent: Color(0xFF5CEBFF),
    universityAccent: Color(0xFF38BDF8),
  ),
  glass: GlassSettings(
    opacity: 0.08,
    blur: 16,
    borderOpacity: 0.12,
    cornerRadius: 20,
    shadowOpacity: 0.25,
  ),
  glow: GlowSettings(
    enabled: true,
    intensity: 0.28,
    radius: 15.0,
  ),
  backgrounds: ThemeBackgrounds(
    home: 'assets/themes/deep_ocean/home_top.webp',
    university: 'assets/themes/deep_ocean/uni.webp',
    calories: 'assets/themes/deep_ocean/calories.webp',
    expenses: 'assets/themes/deep_ocean/expenses.webp',
    routine: 'assets/themes/deep_ocean/routine.webp',
    notes: 'assets/themes/deep_ocean/notes.webp',
    settings: 'assets/themes/deep_ocean/home_bottom.webp',
  ),
  defaultBackgroundMode: BackgroundMode.imageWithOverlay,
  showBackgroundImage: true,
  defaultOverlayOpacity: 0.80,
  previewGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1E38), Color(0xFF06233B), Color(0xFF060B14)],
  ),
);
