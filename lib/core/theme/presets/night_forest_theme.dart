import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/glass_settings.dart';
import '../models/glow_settings.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';

const nightForestTheme = AppThemePreset(
  id: 'night_forest',
  name: 'Night Forest',
  nameAr: 'غابة الليل',
  description: 'Misty forest at night with emerald, deep pine, and warm yellow-green accents',
  descriptionAr: 'أجواء الطبيعة والضباب الليلي مع بريق الزمرد وأخضر الغابات الهادئ',
  colors: ThemeColors(
    background: Color(0xFF060C09),
    backgroundDeep: Color(0xFF030604),
    surface: Color(0xFF0C1812),
    surfaceSecondary: Color(0xFF12241C),
    surfaceElevated: Color(0xFF193126),
    primary: Color(0xFF12C98A), // Emerald green
    secondary: Color(0xFF176A52), // Deep forest green
    highlight: Color(0xFFD5D94A), // Warm yellow-green
    accentCyan: Color(0xFF14B8A6),
    accentGlow: Color(0x3312C98A),
    textPrimary: Color(0xFFF2FDF6),
    textSecondary: Color(0xFF8FAFA2),
    textMuted: Color(0xFF537466),
    success: Color(0xFF12C98A),
    successGlow: Color(0x3312C98A),
    warning: Color(0xFFEAB308),
    warningGlow: Color(0x33EAB308),
    danger: Color(0xFFEF4444),
    dangerGlow: Color(0x33EF4444),
    info: Color(0xFF14B8A6),
    infoGlow: Color(0x3314B8A6),
    border: Color(0x2212C98A),
    borderHighlight: Color(0x4012C98A),
    catFood: Color(0xFFEF4444),
    catTransport: Color(0xFF12C98A),
    catUniversity: Color(0xFF176A52),
    catShopping: Color(0xFFD5D94A),
    catBills: Color(0xFFEAB308),
    catOther: Color(0xFF14B8A6),
    caloriesAccent: Color(0xFFEF4444),
    expensesAccent: Color(0xFFD5D94A),
    routineAccent: Color(0xFF12C98A),
    todoAccent: Color(0xFF176A52),
    notesAccent: Color(0xFFD5D94A),
    universityAccent: Color(0xFF14B8A6),
  ),
  glass: GlassSettings(
    opacity: 0.08,
    blur: 16,
    borderOpacity: 0.12,
    cornerRadius: 20,
    shadowOpacity: 0.22,
  ),
  glow: GlowSettings(
    enabled: true,
    intensity: 0.25,
    radius: 14.0,
  ),
  backgrounds: ThemeBackgrounds(
    home: 'assets/themes/forest_night/home_top.webp',
    university: 'assets/themes/forest_night/uni.webp',
    calories: 'assets/themes/forest_night/calories.webp',
    expenses: 'assets/themes/forest_night/expenses.webp',
    routine: 'assets/themes/forest_night/routine.webp',
    notes: 'assets/themes/forest_night/notes.webp',
    settings: 'assets/themes/forest_night/home_bottom.webp',
  ),
  defaultBackgroundMode: BackgroundMode.imageWithOverlay,
  showBackgroundImage: true,
  defaultOverlayOpacity: 0.82,
  previewGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C2419), Color(0xFF133628), Color(0xFF060C09)],
  ),
);
