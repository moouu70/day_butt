import 'package:flutter/material.dart';

class ThemeColors {
  final Color background;
  final Color backgroundDeep;
  final Color surface;
  final Color surfaceSecondary;
  final Color surfaceElevated;

  final Color primary;
  final Color secondary;
  final Color highlight;
  final Color accentCyan;
  final Color accentGlow;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color success;
  final Color successGlow;
  final Color warning;
  final Color warningGlow;
  final Color danger;
  final Color dangerGlow;
  final Color info;
  final Color infoGlow;

  final Color border;
  final Color borderHighlight;

  final Color catFood;
  final Color catTransport;
  final Color catUniversity;
  final Color catShopping;
  final Color catBills;
  final Color catOther;

  final Color caloriesAccent;
  final Color expensesAccent;
  final Color routineAccent;
  final Color todoAccent;
  final Color notesAccent;
  final Color universityAccent;

  const ThemeColors({
    required this.background,
    Color? backgroundDeep,
    required this.surface,
    required this.surfaceSecondary,
    Color? surfaceElevated,
    required this.primary,
    required this.secondary,
    Color? highlight,
    Color? accentCyan,
    required this.accentGlow,
    this.textPrimary = const Color(0xFFF5F7FA),
    this.textSecondary = const Color(0xFF9BA1AE),
    this.textMuted = const Color(0xFF656B78),
    this.success = const Color(0xFF38D996),
    this.successGlow = const Color(0x3338D996),
    this.warning = const Color(0xFFFFB547),
    this.warningGlow = const Color(0x33FFB547),
    this.danger = const Color(0xFFFF5C70),
    this.dangerGlow = const Color(0x33FF5C70),
    this.info = const Color(0xFF4DBFFF),
    this.infoGlow = const Color(0x334DBFFF),
    this.border = const Color(0x1AFFFFFF),
    this.borderHighlight = const Color(0x33FFFFFF),
    this.catFood = const Color(0xFFFF5C70),
    this.catTransport = const Color(0xFF38D996),
    this.catUniversity = const Color(0xFF7C5CFF),
    this.catShopping = const Color(0xFF4DBFFF),
    this.catBills = const Color(0xFFFFB547),
    this.catOther = const Color(0xFFFFB547),
    this.caloriesAccent = const Color(0xFFFF5C70),
    this.expensesAccent = const Color(0xFFFFB547),
    this.routineAccent = const Color(0xFF38D996),
    this.todoAccent = const Color(0xFF7C5CFF),
    this.notesAccent = const Color(0xFF4DBFFF),
    this.universityAccent = const Color(0xFF7C5CFF),
  })  : backgroundDeep = backgroundDeep ?? background,
        surfaceElevated = surfaceElevated ?? surfaceSecondary,
        highlight = highlight ?? accentCyan ?? const Color(0xFF4DBFFF),
        accentCyan = accentCyan ?? highlight ?? const Color(0xFF4DBFFF);

  LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [primary, secondary],
      );

  LinearGradient get fabGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [secondary, primary],
      );

  LinearGradient get progressGradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [primary, highlight],
      );

  ThemeColors copyWith({
    Color? background,
    Color? backgroundDeep,
    Color? surface,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? primary,
    Color? secondary,
    Color? highlight,
    Color? accentCyan,
    Color? accentGlow,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? success,
    Color? successGlow,
    Color? warning,
    Color? warningGlow,
    Color? danger,
    Color? dangerGlow,
    Color? info,
    Color? infoGlow,
    Color? border,
    Color? borderHighlight,
    Color? catFood,
    Color? catTransport,
    Color? catUniversity,
    Color? catShopping,
    Color? catBills,
    Color? catOther,
    Color? caloriesAccent,
    Color? expensesAccent,
    Color? routineAccent,
    Color? todoAccent,
    Color? notesAccent,
    Color? universityAccent,
  }) {
    final nextHighlight = highlight ?? this.highlight;
    final nextAccentCyan = accentCyan ?? this.accentCyan;

    return ThemeColors(
      background: background ?? this.background,
      backgroundDeep: backgroundDeep ?? this.backgroundDeep,
      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      highlight: nextHighlight,
      accentCyan: nextAccentCyan,
      accentGlow: accentGlow ?? this.accentGlow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      success: success ?? this.success,
      successGlow: successGlow ?? this.successGlow,
      warning: warning ?? this.warning,
      warningGlow: warningGlow ?? this.warningGlow,
      danger: danger ?? this.danger,
      dangerGlow: dangerGlow ?? this.dangerGlow,
      info: info ?? this.info,
      infoGlow: infoGlow ?? this.infoGlow,
      border: border ?? this.border,
      borderHighlight: borderHighlight ?? this.borderHighlight,
      catFood: catFood ?? this.catFood,
      catTransport: catTransport ?? this.catTransport,
      catUniversity: catUniversity ?? this.catUniversity,
      catShopping: catShopping ?? this.catShopping,
      catBills: catBills ?? this.catBills,
      catOther: catOther ?? this.catOther,
      caloriesAccent: caloriesAccent ?? this.caloriesAccent,
      expensesAccent: expensesAccent ?? this.expensesAccent,
      routineAccent: routineAccent ?? this.routineAccent,
      todoAccent: todoAccent ?? this.todoAccent,
      notesAccent: notesAccent ?? this.notesAccent,
      universityAccent: universityAccent ?? this.universityAccent,
    );
  }
}
