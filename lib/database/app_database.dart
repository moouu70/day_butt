import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';
import 'tables/university_events.dart';
import 'tables/calorie_entries.dart';
import 'tables/expense_entries.dart';
import 'tables/routines.dart';
import 'tables/routine_completions.dart';
import 'tables/todos.dart';
import 'tables/notes.dart';
import 'tables/saved_expenses.dart';

part 'app_database.g.dart';

// Default routines seeded on first install
const _defaultRoutines = [
  (name: 'Morning Athkar',      time: '06:00 AM'),
  (name: 'Five Daily Prayers',  time: null),
  (name: 'Daily Reading',       time: '08:00 PM'),
  (name: 'Evening Athkar',      time: '05:00 PM'),
  (name: 'Drink Water',         time: null),
  (name: 'Workout',             time: '07:00 AM'),
  (name: 'Sleep Early',         time: '10:30 PM'),
];

@DriftDatabase(tables: [
  UniversityEvents,
  CalorieEntries,
  ExpenseEntries,
  Routines,
  RoutineCompletions,
  Todos,
  Notes,
  SavedExpenses,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
      : super(e ?? driftDatabase(name: 'day_os_database'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed default routines for new installs
          const uuid = Uuid();
          for (int i = 0; i < _defaultRoutines.length; i++) {
            final r = _defaultRoutines[i];
            await into(routines).insert(
              RoutinesCompanion.insert(
                id: uuid.v4(),
                name: r.name,
                preferredTime: Value(r.time),
                isActive: const Value(true),
                sortOrder: Value(i),
                createdAt: DateTime.now(),
              ),
            );
          }
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(expenseEntries, expenseEntries.type);
          }
          if (from < 3) {
            await m.addColumn(routines, routines.sortOrder);
            await m.createTable(savedExpenses);
          }
        },
      );

  // Convenience helper to clear all user data if requested
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(universityEvents).go();
      await delete(calorieEntries).go();
      await delete(expenseEntries).go();
      await delete(routineCompletions).go();
      await delete(routines).go();
      await delete(todos).go();
      await delete(notes).go();
      await delete(savedExpenses).go();
    });
  }
}
