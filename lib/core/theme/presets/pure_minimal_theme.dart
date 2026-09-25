import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/glass_settings.dart';
import '../models/glow_settings.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';

const pureMinimalTheme = AppThemePreset(
  id: 'pure_minimal',
  name: 'Pure Minimal',
  nameAr: 'بساطة مطلقة',
  description: 'Clean, quiet monochrome with neutral cool gray, soft slate, and zero glow',
  descriptionAr: 'سواد نقي وهدوء بصري بدون مشتتات مع درجات الرمادي الهادئة وخلفية مصمتة',
  colors: ThemeColors(
    background: Color(0xFF090A0D),
    backgroundDeep: Color(0xFF040507),
    surface: Color(0xFF111317),
    surfaceSecondary: Color(0xFF181A20),
    surfaceElevated: Color(0xFF1F222A),
    primary: Color(0xFFA8B2C2), // Neutral cool gray
    secondary: Color(0xFF687080), // Soft gray
    highlight: Color(0xFFE8EDF4), // Near-white
    accentCyan: Color(0xFFE8EDF4),
    accentGlow: Colors.transparent,
    textPrimary: Color(0xFFF1F3F7),
    textSecondary: Color(0xFF9AA1AE),
    textMuted: Color(0xFF5E6470),
    success: Color(0xFF4ADE80),
    successGlow: Colors.transparent,
    warning: Color(0xFFFACC15),
    warningGlow: Colors.transparent,
    danger: Color(0xFFF87171),
    dangerGlow: Colors.transparent,
    info: Color(0xFFA8B2C2),
    infoGlow: Colors.transparent,
    border: Color(0x18A8B2C2),
    borderHighlight: Color(0x30A8B2C2),
    catFood: Color(0xFFF87171),
    catTransport: Color(0xFF4ADE80),
    catUniversity: Color(0xFFA8B2C2),
    catShopping: Color(0xFF687080),
    catBills: Color(0xFFFACC15),
    catOther: Color(0xFFE8EDF4),
    caloriesAccent: Color(0xFFF87171),
    expensesAccent: Color(0xFFFACC15),
    routineAccent: Color(0xFF4ADE80),
    todoAccent: Color(0xFFA8B2C2),
    notesAccent: Color(0xFF687080),
    universityAccent: Color(0xFFA8B2C2),
  ),
  glass: GlassSettings(
    opacity: 0.03,
    blur: 4,
    borderOpacity: 0.07,
    cornerRadius: 18,
    shadowOpacity: 0.0,
  ),
  glow: GlowSettings(
    enabled: false,
    intensity: 0.0,
    radius: 0.0,
  ),
  backgrounds: ThemeBackgrounds(
    home: 'assets/themes/minimal/home_top.webp',
    university: 'assets/themes/minimal/uni.webp',
    calories: 'assets/themes/minimal/calories.webp',
    expenses: 'assets/themes/minimal/expenses.webp',
    routine: 'assets/themes/minimal/routine.webp',
    notes: 'assets/themes/minimal/note.webp',
    settings: 'assets/themes/minimal/home_bottom.webp',
  ),
  defaultBackgroundMode: BackgroundMode.imageWithOverlay,
  showBackgroundImage: true,
  defaultOverlayOpacity: 0.72,
  previewGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF18191E), Color(0xFF0F1014), Color(0xFF090A0D)],
  ),
);
