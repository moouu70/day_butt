import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/date_utils.dart';
import '../services/ticker_provider.dart';
import 'app_database.dart';

/// Singleton Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ==========================================
// DATE SCOPING PROVIDERS (AVOIDS 10S FLICKERING)
// ==========================================

class DayRange {
  final DateTime start;
  final DateTime end;
  const DayRange(this.start, this.end);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Emits the start and end of the current day.
/// Riverpod only notifies dependents when the calendar day rolls over (e.g. midnight),
/// completely preventing database queries from re-triggering every 10 seconds.
final currentDayRangeProvider = Provider<DayRange>((ref) {
  final tickerTime = ref.watch(timeTickerProvider).value ?? DateTime.now();
  return DayRange(
    AppDateUtils.startOfDay(tickerTime),
    AppDateUtils.endOfDay(tickerTime),
  );
});

/// Emits the current day key (YYYY-MM-DD), only updating when day rolls over.
final currentDateKeyProvider = Provider<String>((ref) {
  final tickerTime = ref.watch(timeTickerProvider).value ?? DateTime.now();
  return AppDateUtils.toDateKey(tickerTime);
});

// ==========================================
// UNIVERSITY EVENTS STREAMS & QUERIES
// ==========================================

final universityEventsStreamProvider = StreamProvider<List<UniversityEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.universityEvents)
        ..orderBy([(t) => OrderingTerm(expression: t.dayOfWeek), (t) => OrderingTerm(expression: t.startMinutes)]))
      .watch();
});

// ==========================================
// CALORIES STREAMS & QUERIES
// ==========================================

final allCalorieEntriesStreamProvider = StreamProvider<List<CalorieEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.calorieEntries)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final todayCalorieEntriesStreamProvider = StreamProvider<List<CalorieEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  final range = ref.watch(currentDayRangeProvider);

  return (db.select(db.calorieEntries)
        ..where((t) => t.createdAt.isBiggerOrEqualValue(range.start) & t.createdAt.isSmallerOrEqualValue(range.end))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final todayCaloriesSumStreamProvider = Provider<int>((ref) {
  final entriesAsync = ref.watch(todayCalorieEntriesStreamProvider);
  final entries = entriesAsync.value;
  if (entries != null) {
    return entries.fold<int>(0, (sum, item) => sum + item.calories);
  }
  return 0;
});

// ==========================================
// EXPENSES & INCOMES STREAMS & QUERIES
// ==========================================

final allExpenseEntriesStreamProvider = StreamProvider<List<ExpenseEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.expenseEntries)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final todayExpenseEntriesStreamProvider = StreamProvider<List<ExpenseEntry>>((ref) {
  final db = ref.watch(databaseProvider);
  final range = ref.watch(currentDayRangeProvider);

  return (db.select(db.expenseEntries)
        ..where((t) => t.createdAt.isBiggerOrEqualValue(range.start) & t.createdAt.isSmallerOrEqualValue(range.end))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final todayExpensesSumStreamProvider = Provider<double>((ref) {
  final entriesAsync = ref.watch(todayExpenseEntriesStreamProvider);
  final entries = entriesAsync.value;
  if (entries != null) {
    return entries
        .where((e) => e.type != 'income')
        .fold<double>(0.0, (sum, item) => sum + item.amount);
  }
  return 0.0;
});

final todayIncomeSumStreamProvider = Provider<double>((ref) {
  final entriesAsync = ref.watch(todayExpenseEntriesStreamProvider);
  final entries = entriesAsync.value;
  if (entries != null) {
    return entries
        .where((e) => e.type == 'income')
        .fold<double>(0.0, (sum, item) => sum + item.amount);
  }
  return 0.0;
});

final todayNetSumStreamProvider = Provider<double>((ref) {
  final income = ref.watch(todayIncomeSumStreamProvider);
  final expenses = ref.watch(todayExpensesSumStreamProvider);
  return income - expenses;
});

final todayExpenseCategoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final entriesAsync = ref.watch(todayExpenseEntriesStreamProvider);
  final entries = entriesAsync.value;
  if (entries != null) {
    final map = <String, double>{};
    for (final e in entries.where((e) => e.type != 'income')) {
      map[e.category] = (map[e.category] ?? 0.0) + e.amount;
    }
    return map;
  }
  return <String, double>{};
});

final todayIncomeCategoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final entriesAsync = ref.watch(todayExpenseEntriesStreamProvider);
  final entries = entriesAsync.value;
  if (entries != null) {
    final map = <String, double>{};
    for (final e in entries.where((e) => e.type == 'income')) {
      map[e.category] = (map[e.category] ?? 0.0) + e.amount;
    }
    return map;
  }
  return <String, double>{};
});

// ==========================================
// ROUTINES & DAILY COMPLETIONS
// ==========================================

final activeRoutinesStreamProvider = StreamProvider<List<Routine>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.routines)
        ..where((t) => t.isActive.equals(true))
        ..orderBy([
          (t) => OrderingTerm.asc(t.sortOrder),
          (t) => OrderingTerm.asc(t.createdAt),
        ]))
      .watch();
});

final todayRoutineCompletionsStreamProvider = StreamProvider<List<RoutineCompletion>>((ref) {
  final db = ref.watch(databaseProvider);
  final todayKey = ref.watch(currentDateKeyProvider);

  return (db.select(db.routineCompletions)
        ..where((t) => t.date.equals(todayKey) & t.completed.equals(true)))
      .watch();
});

// ==========================================
// SAVED EXPENSES (PRESETS) STREAMS & QUERIES
// ==========================================

final savedExpensesStreamProvider = StreamProvider<List<SavedExpense>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.savedExpenses)
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .watch();
});

class DailyRoutineItem {
  final Routine routine;
  final bool isCompleted;
  final String? completionId;

  const DailyRoutineItem({
    required this.routine,
    required this.isCompleted,
    this.completionId,
  });
}

final dailyRoutinesProvider = Provider<List<DailyRoutineItem>>((ref) {
  final routinesAsync = ref.watch(activeRoutinesStreamProvider);
  final completionsAsync = ref.watch(todayRoutineCompletionsStreamProvider);

  final routines = routinesAsync.value ?? [];
  final completions = completionsAsync.value ?? [];
  final completedMap = {
    for (var c in completions) c.routineId: c.id,
  };

  return routines.map((r) {
    return DailyRoutineItem(
      routine: r,
      isCompleted: completedMap.containsKey(r.id),
      completionId: completedMap[r.id],
    );
  }).toList();
});

// ==========================================
// TODOS & NOTES
// ==========================================

final todosStreamProvider = StreamProvider<List<Todo>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.todos)
        ..orderBy([
          (t) => OrderingTerm.asc(t.completed),
          (t) => OrderingTerm.desc(t.createdAt),
        ]))
      .watch();
});

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.notes)
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
      .watch();
});

