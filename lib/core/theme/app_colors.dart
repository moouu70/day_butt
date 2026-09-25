import 'package:flutter/material.dart';

/// Design tokens strictly conforming to DAY BUTT UI Visual Specification.
/// Serves as base fallback palette. Theme-aware components should consume
/// `ref.watch(effectiveThemeProvider).colors`.
class AppColors {
  // Base background & surfaces
  static const Color background = Color(0xFF08090B);
  static const Color surfacePrimary = Color(0xFF101216);
  static const Color surfaceSecondary = Color(0xFF171A20);

  // Glass surfaces & borders
  static const Color glassSurface = Color(0x0DFFFFFF); // rgba(255,255,255,0.05)
  static const Color glassSurfaceHover = Color(0x1AFFFFFF); // rgba(255,255,255,0.10)
  static const Color glassBorder = Color(0x1AFFFFFF); // rgba(255,255,255,0.10)
  static const Color glassBorderHighlight = Color(0x33FFFFFF); // rgba(255,255,255,0.20)

  // Typography colors
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF9BA1AE);
  static const Color textMuted = Color(0xFF656B78);

  // Accents
  static const Color accentPrimary = Color(0xFF7C5CFF); // Electric Violet
  static const Color accentSecondary = Color(0xFF9B8CFF);
  static const Color accentCyan = Color(0xFF4DBFFF); // Electric Cyan
  static const Color accentGlow = Color(0x337C5CFF);

  // Semantic Status
  static const Color success = Color(0xFF38D996);
  static const Color successGlow = Color(0x3338D996);
  static const Color warning = Color(0xFFFFB547);
  static const Color warningGlow = Color(0x33FFB547);
  static const Color danger = Color(0xFFFF5C70);
  static const Color dangerGlow = Color(0x33FF5C70);
  static const Color info = Color(0xFF4DBFFF);
  static const Color infoGlow = Color(0x334DBFFF);

  // Category Colors matching reference
  static const Color catFood = Color(0xFFFF5C70);       // Coral Red
  static const Color catTransport = Color(0xFF38D996);  // Mint Teal
  static const Color catUniversity = Color(0xFF7C5CFF); // Electric Violet
  static const Color catShopping = Color(0xFF4DBFFF);   // Cyan Blue
  static const Color catBills = Color(0xFFFFB547);      // Gold Amber
  static const Color catOther = Color(0xFFFFB547);      // Gold Amber

  // Category Accents
  static const Color caloriesAccent = Color(0xFFFF5C70);
  static const Color expensesAccent = Color(0xFFFFB547);
  static const Color routineAccent = Color(0xFF38D996);
  static const Color todoAccent = Color(0xFF7C5CFF);
  static const Color notesAccent = Color(0xFF4DBFFF);
  static const Color universityAccent = Color(0xFF7C5CFF);

  // Linear Gradients
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7C5CFF), Color(0xFF4DBFFF)],
  );

  static const LinearGradient fabGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B6CFF), Color(0xFF623CEE)],
  );

  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7C5CFF), Color(0xFF4DBFFF)],
  );
}
