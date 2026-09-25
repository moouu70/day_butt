import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:day_butt/core/localization/app_localizations.dart';
import 'package:day_butt/database/app_database.dart';
import 'package:day_butt/database/database_provider.dart';
import 'package:day_butt/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders greeting, metrics row, and quick actions', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: const Locale('en'),
          home: HomeScreen(onTabSelected: (_) {}),
        ),
      ),
    );

    // Initial pump and frame
    await tester.pumpAndSettle();

    // Verify header Mohammed & greeting
    expect(find.textContaining('Mohammed'), findsOneWidget);

    // Verify sections
    expect(find.text("Today's Tasks"), findsOneWidget);
    expect(find.text('Quick Note'), findsOneWidget);

    // Verify metrics and quick action labels
    expect(find.text('Calories'), findsWidgets);
    expect(find.text('Expense'), findsWidgets);
    expect(find.text('Routines'), findsWidgets);

    await db.close();
  });

  testWidgets('HomeScreen expands tasks and notes when + more is clicked', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    // Insert 5 todos
    for (int i = 1; i <= 5; i++) {
      await db.into(db.todos).insert(
        TodosCompanion.insert(
          id: 'todo_$i',
          title: 'Task number $i',
          createdAt: DateTime.now(),
        ),
      );
    }

    // Insert 5 notes
    for (int i = 1; i <= 5; i++) {
      await db.into(db.notes).insert(
        NotesCompanion.insert(
          id: 'note_$i',
          content: 'Note content $i',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: const Locale('en'),
          home: HomeScreen(onTabSelected: (_) {}),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial preview limit (4 tasks rendered, Task number 5 not yet visible)
    expect(find.text('Task number 1'), findsOneWidget);
    expect(find.text('Task number 4'), findsOneWidget);
    expect(find.text('Task number 5'), findsNothing);

    // Verify "+ 1 more" is present for tasks
    expect(find.text('+ 1 more'), findsWidgets);

    // Scroll to "+ 1 more" and tap
    await tester.ensureVisible(find.text('+ 1 more').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ 1 more').first);
    await tester.pumpAndSettle();

    // Now Task number 5 should be visible!
    expect(find.text('Task number 5'), findsOneWidget);
    expect(find.text('Show less'), findsWidgets);

    // Tap "Show less"
    await tester.ensureVisible(find.text('Show less').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show less').first);
    await tester.pumpAndSettle();

    // Task number 5 collapsed
    expect(find.text('Task number 5'), findsNothing);

    await db.close();
  });
}
