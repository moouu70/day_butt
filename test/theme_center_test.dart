import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_butt/core/localization/app_localizations.dart';
import 'package:day_butt/core/theme/models/background_mode.dart';
import 'package:day_butt/core/theme/models/background_slot.dart';
import 'package:day_butt/core/theme/models/user_theme_overrides.dart';
import 'package:day_butt/core/theme/presets/app_presets.dart';
import 'package:day_butt/core/theme/providers/theme_provider.dart';
import 'package:day_butt/core/theme/resolver/theme_resolver.dart';
import 'package:day_butt/features/theme_center/presentation/theme_center_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Theme Center - Presets Suite', () {
    test('All required presets including Japan Aesthetic are registered', () {
      expect(kAppThemePresets.length, equals(8));
      final ids = kAppThemePresets.map((p) => p.id).toSet();
      expect(ids, containsAll([
        'midnight',
        'sakura_night',
        'samurai_night',
        'deep_ocean',
        'night_forest',
        'sunset',
        'pure_minimal',
        'aurora',
      ]));
    });

    test('Each preset defines English and Arabic names and descriptions', () {
      for (final preset in kAppThemePresets) {
        expect(preset.getName(false), isNotEmpty);
        expect(preset.getName(true), isNotEmpty);
        expect(preset.getDescription(false), isNotEmpty);
        expect(preset.getDescription(true), isNotEmpty);
      }
    });

    test('Pure Minimal theme has restrained visual effects', () {
      expect(pureMinimalTheme.glow.enabled, isFalse);
      expect(pureMinimalTheme.defaultBackgroundMode, equals(BackgroundMode.solid));
      expect(pureMinimalTheme.showBackgroundImage, isFalse);
    });

    test('Sakura Night theme has cinematic background mode', () {
      expect(sakuraNightTheme.glow.enabled, isTrue);
      expect(sakuraNightTheme.defaultBackgroundMode, equals(BackgroundMode.imageWithOverlay));
      expect(sakuraNightTheme.showBackgroundImage, isTrue);
    });

    test('Japan Aesthetic / Samurai Night theme conforms to crimson and violet palette', () {
      expect(samuraiNightTheme.colors.background, equals(const Color(0xFF050812)));
      expect(samuraiNightTheme.colors.primary, equals(const Color(0xFFD83A4A)));
      expect(samuraiNightTheme.colors.secondary, equals(const Color(0xFF6A466D)));
      expect(samuraiNightTheme.colors.highlight, equals(const Color(0xFFFF6574)));
      expect(samuraiNightTheme.colors.textPrimary, equals(const Color(0xFFF4EDE2)));
      expect(samuraiNightTheme.backgrounds.home, equals('assets/themes/japan/japan_home_top.png'));
    });
  });

  group('Theme Center - ThemeResolver Suite', () {
    test('Resolves base preset with zero overrides', () {
      final effective = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: UserThemeOverrides.empty,
      );

      expect(effective.colors.primary, equals(midnightTheme.colors.primary));
      expect(effective.glass.blur, equals(midnightTheme.glass.blur));
      expect(effective.glow.enabled, equals(midnightTheme.glow.enabled));
      expect(effective.backgroundMode, equals(midnightTheme.defaultBackgroundMode));
    });

    test('Applies custom accent color override and computes harmonious secondary', () {
      const customColor = Color(0xFF3B82F6); // Blue
      final effective = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: const UserThemeOverrides(customAccent: customColor),
      );

      expect(effective.colors.primary, equals(customColor));
      expect(effective.colors.secondary, isNot(equals(midnightTheme.colors.secondary)));
    });

    test('Applies visual intensity overrides for glass and blur', () {
      final effective = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: const UserThemeOverrides(
          glassIntensity: VisualIntensity.high,
          blurIntensity: VisualIntensity.low,
        ),
      );

      expect(effective.glass.opacity, greaterThan(midnightTheme.glass.opacity));
      expect(effective.glass.blur, equals(6.0));
    });

    test('Applies glow intensity override', () {
      final effectiveOff = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: const UserThemeOverrides(glowIntensity: VisualIntensity.off),
      );
      expect(effectiveOff.glow.enabled, isFalse);

      final effectiveHigh = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: const UserThemeOverrides(glowIntensity: VisualIntensity.high),
      );
      expect(effectiveHigh.glow.enabled, isTrue);
      expect(effectiveHigh.glow.intensity, equals(0.50));
    });

    test('Applies per-slot background overrides', () {
      final effective = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: const UserThemeOverrides(
          slotBackgrounds: {
            BackgroundSlot.home: 'assets/themes/sakura/home.webp',
          },
        ),
      );

      expect(effective.backgrounds.home, equals('assets/themes/sakura/home.webp'));
      expect(effective.backgrounds.university, equals(midnightTheme.backgrounds.university));
    });
  });

  group('Theme Center - Serialization & Persistence Suite', () {
    test('UserThemeOverrides serializes to clean JSON format', () {
      const overrides = UserThemeOverrides(
        customAccent: Color(0xFF7C5CFF),
        glassIntensity: VisualIntensity.high,
        blurIntensity: VisualIntensity.medium,
        glowIntensity: VisualIntensity.low,
        backgroundMode: BackgroundMode.imageWithOverlay,
        slotBackgrounds: {
          BackgroundSlot.home: 'custom_home_path',
        },
        customSlotImages: {
          BackgroundSlot.calories: '/data/user/calories.jpg',
        },
      );

      final jsonMap = overrides.toJson();
      expect(jsonMap['accent'], equals('#ff7c5cff'));
      expect(jsonMap['glassIntensity'], equals('high'));
      expect(jsonMap['blur'], equals('medium'));
      expect(jsonMap['glow'], equals('low'));
      expect(jsonMap['backgroundMode'], equals('imageWithOverlay'));
      expect((jsonMap['slotBackgrounds'] as Map)['home'], equals('custom_home_path'));
      expect((jsonMap['customSlotImages'] as Map)['calories'], equals('/data/user/calories.jpg'));

      final jsonString = jsonEncode(jsonMap);
      final decodedMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final restored = UserThemeOverrides.fromJson(decodedMap);

      expect(restored.customAccent?.value, equals(const Color(0xFF7C5CFF).value));
      expect(restored.glassIntensity, equals(VisualIntensity.high));
      expect(restored.blurIntensity, equals(VisualIntensity.medium));
      expect(restored.glowIntensity, equals(VisualIntensity.low));
      expect(restored.backgroundMode, equals(BackgroundMode.imageWithOverlay));
      expect(restored.slotBackgrounds[BackgroundSlot.home], equals('custom_home_path'));
      expect(restored.customSlotImages[BackgroundSlot.calories], equals('/data/user/calories.jpg'));
    });
  });

  group('Theme Center - Provider & State Suite', () {
    test('ThemeNotifier changes preset reactively', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeProvider).preset.id, equals('midnight'));

      container.read(themeProvider.notifier).setPreset(sakuraNightTheme);
      expect(container.read(themeProvider).preset.id, equals('sakura_night'));
      expect(container.read(effectiveThemeProvider).colors.primary, equals(sakuraNightTheme.colors.primary));
    });

    test('ThemeNotifier resets to default Midnight theme', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeProvider.notifier).setPreset(sakuraNightTheme);
      container.read(themeProvider.notifier).setAccentColor(const Color(0xFF10B981));
      expect(container.read(themeProvider).preset.id, equals('sakura_night'));

      await container.read(themeProvider.notifier).resetToDefaults();
      expect(container.read(themeProvider).preset.id, equals('midnight'));
      expect(container.read(themeProvider).overrides.customAccent, isNull);
    });
  });

  group('Theme Center - UI & Widget Suite', () {
    testWidgets('ThemeCenterScreen renders all sections in English', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            locale: Locale('en'),
            supportedLocales: [Locale('en'), Locale('ar')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: ThemeCenterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ThemeCenterScreen), findsOneWidget);
      expect(find.text('Theme Center'), findsOneWidget);
      expect(find.text('PRESETS'), findsOneWidget);
    });

    testWidgets('ThemeCenterScreen renders in Arabic without errors', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            locale: Locale('ar'),
            supportedLocales: [Locale('en'), Locale('ar')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: ThemeCenterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ThemeCenterScreen), findsOneWidget);
      expect(find.text('مركز السمات'), findsOneWidget);
      expect(find.text('السمات الجاهزة'), findsOneWidget);
    });
  });
}
