import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:day_butt/core/localization/app_localizations.dart';
import 'package:day_butt/core/theme/models/user_theme_overrides.dart';
import 'package:day_butt/core/theme/presets/app_presets.dart';
import 'package:day_butt/core/theme/resolver/theme_resolver.dart';
import 'package:day_butt/core/theme/services/theme_dna_formatter.dart';
import 'package:day_butt/features/theme_center/presentation/widgets/theme_dna_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Theme DNA Formatter Suite', () {
    test('Formats all 8 built-in presets with complete structure and placeholder', () {
      for (final preset in kAppThemePresets) {
        final theme = ThemeResolver.resolve(
          preset: preset,
          overrides: const UserThemeOverrides(),
        );

        final dna = ThemeDnaFormatter.format(theme);

        // Header check
        expect(dna, contains('DAY BUTT — ${preset.name.toUpperCase()}'));
        expect(dna, contains('THEME DNA'));

        // Wallpaper request placeholder check
        expect(dna, contains('WALLPAPER REQUEST:'));
        expect(
          dna,
          contains('[DESCRIBE THE WALLPAPER / SCENE YOU WANT TO GENERATE HERE]'),
        );

        // Core sections check
        expect(dna, contains('THEME VISUAL DNA'));
        expect(dna, contains('Visual Identity:'));
        expect(dna, contains('Color Palette:'));
        expect(dna, contains('Color Distribution:'));
        expect(dna, contains('Mood:'));
        expect(dna, contains('Lighting:'));
        expect(dna, contains('Atmosphere:'));
        expect(dna, contains('Materials:'));
        expect(dna, contains('Environment:'));
        expect(dna, contains('Visual Motifs:'));
        expect(dna, contains('Art Direction:'));
        expect(dna, contains('Composition:'));
        expect(dna, contains('UI Compatibility:'));
        expect(dna, contains('Image Requirements:'));
        expect(dna, contains('Avoid:'));
        expect(dna, contains('GENERATION INSTRUCTION'));

        // Hex color checks
        final primaryHex = ThemeDnaFormatter.colorToHex(preset.colors.primary);
        expect(dna, contains('Primary: $primaryHex'));
        final bgHex = ThemeDnaFormatter.colorToHex(preset.colors.background);
        expect(dna, contains('Background: $bgHex'));
      }
    });

    test('Dynamically updates hex values when theme colors are customized', () {
      const customPrimary = Color(0xFFFF0055);
      final theme = ThemeResolver.resolve(
        preset: midnightTheme,
        overrides: const UserThemeOverrides(customAccent: customPrimary),
      );

      final dna = ThemeDnaFormatter.format(theme);
      expect(dna, contains('Primary: #FF0055'));
    });
  });

  group('Theme DNA UI Suite', () {
    Widget buildTestWidget({Locale locale = const Locale('en')}) {
      return ProviderScope(
        child: MaterialApp(
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ThemeDnaSection(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('ThemeDnaSection renders header and both View & Copy buttons in English', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('THEME DNA'), findsWidgets);
      expect(find.text("Use this theme's visual identity to create matching artwork with AI."), findsOneWidget);
      expect(find.text('View DNA'), findsOneWidget);
      expect(find.text('Copy DNA'), findsOneWidget);
    });

    testWidgets('ThemeDnaSection renders properly in Arabic', (tester) async {
      await tester.pumpWidget(buildTestWidget(locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('الهوية البصرية (DNA)'), findsWidgets);
      expect(find.text('معاينة الهوية'), findsOneWidget);
      expect(find.text('نسخ الهوية (DNA)'), findsOneWidget);
    });

    testWidgets('Tapping Copy DNA copies string and displays SnackBar', (tester) async {
      final List<MethodCall> log = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        log.add(call);
        return null;
      });

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final copyButton = find.text('Copy DNA');
      await tester.tap(copyButton);
      await tester.pumpAndSettle();

      // Check SnackBar message
      expect(find.text('Theme DNA copied'), findsOneWidget);

      // Verify clipboard interaction
      final clipboardCalls = log.where((c) => c.method == 'Clipboard.setData');
      expect(clipboardCalls, isNotEmpty);
      final copiedData = (clipboardCalls.first.arguments as Map)['text'] as String;
      expect(copiedData, contains('DAY BUTT — MIDNIGHT'));
      expect(copiedData, contains('[DESCRIBE THE WALLPAPER / SCENE YOU WANT TO GENERATE HERE]'));
    });

    testWidgets('Tapping View DNA opens preview sheet with selectable DNA text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final viewButton = find.text('View DNA');
      await tester.tap(viewButton);
      await tester.pumpAndSettle();

      // Modal is presented
      expect(find.text('Theme Visual DNA'), findsOneWidget);
      expect(find.byType(SelectableText), findsOneWidget);
      final selectableWidget = tester.widget<SelectableText>(find.byType(SelectableText));
      expect(selectableWidget.data, contains('DAY BUTT — MIDNIGHT'));
      expect(selectableWidget.data, contains('THEME VISUAL DNA'));
    });
  });
}
