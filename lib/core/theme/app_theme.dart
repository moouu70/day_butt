import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_typography.dart';
import 'models/effective_theme.dart';
import 'presets/midnight_theme.dart';
import 'resolver/theme_resolver.dart';
import 'models/user_theme_overrides.dart';

class AppTheme {
  static ThemeData get darkTheme => getTheme(isArabic: false);

  static ThemeData getTheme({
    bool isArabic = false,
    EffectiveTheme? theme,
  }) {
    final activeTheme = theme ??
        ThemeResolver.resolve(
          preset: midnightTheme,
          overrides: UserThemeOverrides.empty,
        );
    final colors = activeTheme.colors;
    final activeFont = isArabic ? AppTypography.arabicFontFamily : AppTypography.fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.background,
      fontFamily: activeFont,
      fontFamilyFallback: const [AppTypography.arabicFontFamily, AppTypography.fontFamily],
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.textPrimary,
        secondary: colors.secondary,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.danger,
        onError: colors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: colors.background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.pageTitle,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.border, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceSecondary,
        contentTextStyle: AppTypography.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.border),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

