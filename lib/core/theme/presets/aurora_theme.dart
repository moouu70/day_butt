import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/glass_settings.dart';
import '../models/glow_settings.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';

const auroraTheme = AppThemePreset(
  id: 'aurora',
  name: 'Aurora',
  nameAr: 'الشفق القطبي',
  description: 'Atmospheric northern lights with cyan, violet, and soft aqua glows',
  descriptionAr: 'أضواء الشفق القطبي المذهلة مع مزيج التيل الكهربائي والبنفسجي الكوني',
  colors: ThemeColors(
    background: Color(0xFF060B12),
    backgroundDeep: Color(0xFF03060A),
    surface: Color(0xFF0D1622),
    surfaceSecondary: Color(0xFF132030),
    surfaceElevated: Color(0xFF1A2A3E),
    primary: Color(0xFF00DDBB), // Cyan
    secondary: Color(0xFF7657FF), // Violet
    highlight: Color(0xFF72F2D2), // Soft green / aqua
    accentCyan: Color(0xFF72F2D2),
    accentGlow: Color(0x3300DDBB),
    textPrimary: Color(0xFFF0FDFA),
    textSecondary: Color(0xFF8FAEB6),
    textMuted: Color(0xFF537078),
    success: Color(0xFF00DDBB),
    successGlow: Color(0x3300DDBB),
    warning: Color(0xFFFBBF24),
    warningGlow: Color(0x33FBBF24),
    danger: Color(0xFFF43F5E),
    dangerGlow: Color(0x33F43F5E),
    info: Color(0xFF7657FF),
    infoGlow: Color(0x337657FF),
    border: Color(0x2200DDBB),
    borderHighlight: Color(0x4000DDBB),
    catFood: Color(0xFFF43F5E),
    catTransport: Color(0xFF00DDBB),
    catUniversity: Color(0xFF7657FF),
    catShopping: Color(0xFF72F2D2),
    catBills: Color(0xFFFBBF24),
    catOther: Color(0xFF72F2D2),
    caloriesAccent: Color(0xFFF43F5E),
    expensesAccent: Color(0xFFFBBF24),
    routineAccent: Color(0xFF00DDBB),
    todoAccent: Color(0xFF7657FF),
    notesAccent: Color(0xFF72F2D2),
    universityAccent: Color(0xFF7657FF),
  ),
  glass: GlassSettings(
    opacity: 0.08,
    blur: 16,
    borderOpacity: 0.14,
    cornerRadius: 20,
    shadowOpacity: 0.24,
  ),
  glow: GlowSettings(
    enabled: true,
    intensity: 0.28,
    radius: 15.0,
  ),
  backgrounds: ThemeBackgrounds(
    home: 'assets/themes/aurora/home_top.webp',
    university: 'assets/themes/aurora/uni.webp',
    calories: 'assets/themes/aurora/calories.webp',
    expenses: 'assets/themes/aurora/expenses.webp',
    routine: 'assets/themes/aurora/routine.webp',
    notes: 'assets/themes/aurora/notes.webp',
    settings: 'assets/themes/aurora/home_bottom.webp',
  ),
  defaultBackgroundMode: BackgroundMode.imageWithOverlay,
  showBackgroundImage: true,
  defaultOverlayOpacity: 0.80,
  previewGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B212D), Color(0xFF1B173B), Color(0xFF060B12)],
  ),
);
