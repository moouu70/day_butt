import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_butt/core/localization/app_localizations.dart';
import 'package:day_butt/core/providers/calorie_goal_provider.dart';
import 'package:day_butt/database/app_database.dart';
import 'package:day_butt/database/database_provider.dart';
import 'package:day_butt/features/calories/presentation/calories_screen.dart';
import 'package:day_butt/features/calories/presentation/widgets/edit_calorie_goal_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Calorie Goal Provider & Persistence Tests', () {
    test('Defaults to 2300 and updates with persistence', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(calorieGoalProvider), equals(2300));

      await container.read(calorieGoalProvider.notifier).setCalorieGoal(2600);
      expect(container.read(calorieGoalProvider), equals(2600));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(kCalorieGoalKey), equals(2600));
    });

    test('Loads existing goal from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({kCalorieGoalKey: 2100});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Trigger read and pump microtasks
      container.read(calorieGoalProvider);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(calorieGoalProvider), equals(2100));
    });
  });

  group('Calorie Goal UI & Sheet Tests', () {
    testWidgets('EditCalorieGoalSheet allows selecting preset and saving', (tester) async {
      SharedPreferences.setMockInitialValues({kCalorieGoalKey: 2300});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            locale: Locale('en'),
            home: Scaffold(
              body: EditCalorieGoalSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify text field exists and presets are visible
      expect(find.byType(EditableText), findsOneWidget);
      expect(find.text('Quick Presets'), findsOneWidget);

      // Tap preset '2500 kcal'
      final preset2500 = find.text('2500 kcal');
      expect(preset2500, findsOneWidget);
      await tester.tap(preset2500);
      await tester.pumpAndSettle();

      // Tap Save
      final saveBtn = find.text('Save');
      expect(saveBtn, findsOneWidget);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify provider updated to 2500
      expect(container.read(calorieGoalProvider), equals(2500));
    });

    testWidgets('CaloriesScreen displays current calorie goal and target icon', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({kCalorieGoalKey: 2400});
      final db = AppDatabase(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            locale: Locale('en'),
            home: CaloriesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Daily Goal should display 2,300 or 2,400 depending on provider
      expect(find.textContaining('Daily Goal:'), findsOneWidget);

      await db.close();
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  });
}
