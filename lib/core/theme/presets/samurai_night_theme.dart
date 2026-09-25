import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/glass_settings.dart';
import '../models/glow_settings.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';

/// JAPAN AESTHETIC / SAMURAI NIGHT
/// Harmonized with Japanese night background collection.
/// Dark, cinematic, Japanese, warm, disciplined, premium, subtle.
const samuraiNightTheme = AppThemePreset(
  id: 'samurai_night',
  name: 'Japan Aesthetic',
  nameAr: 'أجواء اليابان',
  description: 'Crimson red, deep muted violet, and warm lantern highlights',
  descriptionAr: 'أجواء يابانية أصيلة مع أحمر القيقب ودفء الفوانيس والبنفسجي الداكن',
  colors: ThemeColors(
    background: Color(0xFF050812),
    backgroundDeep: Color(0xFF02040A),
    surface: Color(0xFF101522),
    surfaceSecondary: Color(0xFF171C2A),
    surfaceElevated: Color(0xFF1D2334),
    primary: Color(0xFFD83A4A), // Crimson red
    secondary: Color(0xFF6A466D), // Deep muted violet
    highlight: Color(0xFFFF6574), // Warm lantern pink/red
    accentCyan: Color(0xFF7183A6), // Japanese night sky slate
    accentGlow: Color(0x33D83A4A),
    textPrimary: Color(0xFFF4EDE2), // Warm rice paper
    textSecondary: Color(0xFFB8B0AA), // Warm sand
    textMuted: Color(0xFF77727A),
    success: Color(0xFF5F9B82), // Zen pine / sage green
    successGlow: Color(0x335F9B82),
    warning: Color(0xFFD89A4A), // Lantern amber
    warningGlow: Color(0x33D89A4A),
    danger: Color(0xFFD6424B), // Torii crimson red
    dangerGlow: Color(0x33D6424B),
    info: Color(0xFF7183A6), // Night slate blue
    infoGlow: Color(0x337183A6),
    border: Color(0x3549303A), // Subtle dark maple border
    borderHighlight: Color(0x55D83A4A),
    catFood: Color(0xFFD83A4A),
    catTransport: Color(0xFF5F9B82),
    catUniversity: Color(0xFF7183A6),
    catShopping: Color(0xFFD89A4A),
    catBills: Color(0xFFD89A4A),
    catOther: Color(0xFF6A466D),
    caloriesAccent: Color(0xFFD83A4A), // Crimson
    expensesAccent: Color(0xFFD89A4A), // Lantern amber
    routineAccent: Color(0xFF5F9B82), // Zen sage
    todoAccent: Color(0xFF6A466D), // Deep muted violet
    notesAccent: Color(0xFFFF6574), // Warm lantern highlight
    universityAccent: Color(0xFF7183A6), // Japanese night slate
  ),
  glass: GlassSettings(
    opacity: 0.10,
    blur: 18,
    borderOpacity: 0.15,
    cornerRadius: 20,
    shadowOpacity: 0.24,
  ),
  glow: GlowSettings(
    enabled: true,
    intensity: 0.24, // Warm lantern glow, avoid neon
    radius: 14.0,
  ),
  backgrounds: ThemeBackgrounds(
    home: 'assets/themes/japan/japan_home_top.webp',
    university: 'assets/themes/japan/japan_uni.webp',
    calories: 'assets/themes/japan/japan_calories.webp',
    expenses: 'assets/themes/japan/japan_expenses.webp',
    routine: 'assets/themes/japan/japan_routine.webp',
    notes: 'assets/themes/japan/japan_notes.webp',
    settings: 'assets/themes/japan/japan_home_bottom.webp',
  ),
  defaultBackgroundMode: BackgroundMode.imageWithOverlay,
  showBackgroundImage: true,
  defaultOverlayOpacity: 0.80,
  previewGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF101522), Color(0xFF171C2A), Color(0xFF050812)],
  ),
);
