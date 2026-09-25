import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:day_butt/core/utils/date_utils.dart';
import 'package:day_butt/database/app_database.dart';
import 'package:day_butt/services/backup_service.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Database & Backup Tests', () {
    test('Can insert and retrieve calorie entries', () async {
      await db.into(db.calorieEntries).insert(
        CalorieEntriesCompanion.insert(
          id: 'cal_1',
          calories: 650,
          note: const drift.Value('Chicken Sandwich'),
          createdAt: DateTime.now(),
        ),
      );

      final entries = await db.select(db.calorieEntries).get();
      expect(entries.length, equals(1));
      expect(entries.first.calories, equals(650));
      expect(entries.first.note, equals('Chicken Sandwich'));
    });

    test('Can insert and retrieve expense entries', () async {
      await db.into(db.expenseEntries).insert(
        ExpenseEntriesCompanion.insert(
          id: 'exp_1',
          amount: 120.50,
          category: 'Food',
          note: const drift.Value('Lunch'),
          createdAt: DateTime.now(),
        ),
      );

      final entries = await db.select(db.expenseEntries).get();
      expect(entries.length, equals(1));
      expect(entries.first.amount, equals(120.50));
      expect(entries.first.category, equals('Food'));
      expect(entries.first.type, equals('expense')); // default is expense
    });

    test('Can insert and distinguish expense and income entries', () async {
      await db.into(db.expenseEntries).insert(
        ExpenseEntriesCompanion.insert(
          id: 'exp_test',
          amount: 100.0,
          category: 'Food',
          type: const drift.Value('expense'),
          createdAt: DateTime.now(),
        ),
      );

      await db.into(db.expenseEntries).insert(
        ExpenseEntriesCompanion.insert(
          id: 'inc_test',
          amount: 500.0,
          category: 'Salary',
          type: const drift.Value('income'),
          createdAt: DateTime.now(),
        ),
      );

      final entries = await db.select(db.expenseEntries).get();
      expect(entries.length, equals(2));

      final expenses = entries.where((e) => e.type == 'expense').toList();
      final incomes = entries.where((e) => e.type == 'income').toList();

      expect(expenses.length, equals(1));
      expect(expenses.first.amount, equals(100.0));
      expect(incomes.length, equals(1));
      expect(incomes.first.amount, equals(500.0));
      expect(incomes.first.category, equals('Salary'));
    });

    test('Routine daily completions work per date key without mutating routine', () async {
      await db.into(db.routines).insert(
        RoutinesCompanion.insert(
          id: 'routine_1',
          name: 'Study 2 hours',
          createdAt: DateTime.now(),
        ),
      );

      final todayKey = AppDateUtils.toDateKey(DateTime.now());

      // Mark completed for today
      await db.into(db.routineCompletions).insert(
        RoutineCompletionsCompanion.insert(
          id: 'comp_1',
          routineId: 'routine_1',
          date: todayKey,
          completedAt: DateTime.now(),
        ),
      );

      final routines = await db.select(db.routines).get();
      expect(routines.length, equals(1));

      final completions = await (db.select(db.routineCompletions)
            ..where((t) => t.date.equals(todayKey)))
          .get();
      expect(completions.length, equals(1));
      expect(completions.first.routineId, equals('routine_1'));
    });

    test('BackupService exports and restores all database tables accurately', () async {
      // Insert sample across multiple tables
      await db.into(db.calorieEntries).insert(
        CalorieEntriesCompanion.insert(
          id: 'cal_backup',
          calories: 450,
          createdAt: DateTime.now(),
        ),
      );

      await db.into(db.todos).insert(
        TodosCompanion.insert(
          id: 'todo_backup',
          title: 'Finish Assignment',
          completed: const drift.Value(false),
          createdAt: DateTime.now(),
        ),
      );

      final backupService = BackupService(db);
      final jsonBackup = await backupService.exportBackupJson();

      expect(jsonBackup.contains('cal_backup'), isTrue);
      expect(jsonBackup.contains('todo_backup'), isTrue);
      expect(jsonBackup.contains('"version": 1'), isTrue);

      // Now clear and restore
      await db.clearAllData();
      final emptyTodos = await db.select(db.todos).get();
      expect(emptyTodos, isEmpty);

      final success = await backupService.importBackupJson(jsonBackup);
      expect(success, isTrue);

      final restoredTodos = await db.select(db.todos).get();
      expect(restoredTodos.length, equals(1));
      expect(restoredTodos.first.title, equals('Finish Assignment'));
    });
  });
}
