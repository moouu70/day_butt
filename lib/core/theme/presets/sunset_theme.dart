import 'package:flutter/material.dart';
import '../models/app_theme_preset.dart';
import '../models/background_mode.dart';
import '../models/glass_settings.dart';
import '../models/glow_settings.dart';
import '../models/theme_backgrounds.dart';
import '../models/theme_colors.dart';

const sunsetTheme = AppThemePreset(
  id: 'sunset',
  name: 'Sunset',
  nameAr: 'غروب الشمس',
  description: 'Warm dusk twilight with warm orange, deep amber, and coral hues',
  descriptionAr: 'دفء الغروب مع تدرجات البرتقالي الدافئ والعنبر الذهبي والمرجان',
  colors: ThemeColors(
    background: Color(0xFF0E0807),
    backgroundDeep: Color(0xFF070403),
    surface: Color(0xFF18100E),
    surfaceSecondary: Color(0xFF221613),
    surfaceElevated: Color(0xFF2C1D19),
    primary: Color(0xFFFF7800), // Warm orange
    secondary: Color(0xFFB86A19), // Deep amber
    highlight: Color(0xFFFF4D3D), // Coral orange/red
    accentCyan: Color(0xFFFF4D3D),
    accentGlow: Color(0x33FF7800),
    textPrimary: Color(0xFFFFF7ED),
    textSecondary: Color(0xFFB8A196),
    textMuted: Color(0xFF786055),
    success: Color(0xFF10B981),
    successGlow: Color(0x3310B981),
    warning: Color(0xFFFF7800),
    warningGlow: Color(0x33FF7800),
    danger: Color(0xFFFF4D3D),
    dangerGlow: Color(0x33FF4D3D),
    info: Color(0xFFF97316),
    infoGlow: Color(0x33F97316),
    border: Color(0x22FF7800),
    borderHighlight: Color(0x40FF7800),
    catFood: Color(0xFFFF4D3D),
    catTransport: Color(0xFF10B981),
    catUniversity: Color(0xFFB86A19),
    catShopping: Color(0xFFFF7800),
    catBills: Color(0xFFB86A19),
    catOther: Color(0xFFFF4D3D),
    caloriesAccent: Color(0xFFFF4D3D),
    expensesAccent: Color(0xFFB86A19),
    routineAccent: Color(0xFF10B981),
    todoAccent: Color(0xFFFF7800),
    notesAccent: Color(0xFFFF4D3D),
    universityAccent: Color(0xFFB86A19),
  ),
  glass: GlassSettings(
    opacity: 0.08,
    blur: 16,
    borderOpacity: 0.14,
    cornerRadius: 20,
    shadowOpacity: 0.22,
  ),
  glow: GlowSettings(
    enabled: true,
    intensity: 0.26,
    radius: 14.0,
  ),
  backgrounds: ThemeBackgrounds(
    home: 'assets/themes/sunset/home_top.webp',
    university: 'assets/themes/sunset/uni.webp',
    calories: 'assets/themes/sunset/calories.webp',
    expenses: 'assets/themes/sunset/expensies.webp',
    routine: 'assets/themes/sunset/routine.webp',
    notes: 'assets/themes/sunset/note.webp',
    settings: 'assets/themes/sunset/home_bottom.webp',
  ),
  defaultBackgroundMode: BackgroundMode.imageWithOverlay,
  showBackgroundImage: true,
  defaultOverlayOpacity: 0.82,
  previewGradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF24100E), Color(0xFF1C0D11), Color(0xFF0E0807)],
  ),
);
