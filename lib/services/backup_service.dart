import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  /// Exports all tables to a versioned JSON string
  Future<String> exportBackupJson() async {
    final uniEvents = await db.select(db.universityEvents).get();
    final calories = await db.select(db.calorieEntries).get();
    final expenses = await db.select(db.expenseEntries).get();
    final routines = await db.select(db.routines).get();
    final completions = await db.select(db.routineCompletions).get();
    final todos = await db.select(db.todos).get();
    final notes = await db.select(db.notes).get();

    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'university': uniEvents.map((e) => {
        'id': e.id,
        'dayOfWeek': e.dayOfWeek,
        'startMinutes': e.startMinutes,
        'endMinutes': e.endMinutes,
        'subject': e.subject,
        'type': e.type,
        'location': e.location,
        'instructor': e.instructor,
      }).toList(),
      'calories': calories.map((e) => {
        'id': e.id,
        'calories': e.calories,
        'note': e.note,
        'createdAt': e.createdAt.toIso8601String(),
      }).toList(),
      'expenses': expenses.map((e) => {
        'id': e.id,
        'amount': e.amount,
        'category': e.category,
        'type': e.type,
        'note': e.note,
        'createdAt': e.createdAt.toIso8601String(),
      }).toList(),
      'routines': routines.map((e) => {
        'id': e.id,
        'name': e.name,
        'icon': e.icon,
        'preferredTime': e.preferredTime,
        'isActive': e.isActive,
        'createdAt': e.createdAt.toIso8601String(),
      }).toList(),
      'routineCompletions': completions.map((e) => {
        'id': e.id,
        'routineId': e.routineId,
        'date': e.date,
        'completed': e.completed,
        'completedAt': e.completedAt.toIso8601String(),
      }).toList(),
      'todos': todos.map((e) => {
        'id': e.id,
        'title': e.title,
        'completed': e.completed,
        'createdAt': e.createdAt.toIso8601String(),
        'completedAt': e.completedAt?.toIso8601String(),
      }).toList(),
      'notes': notes.map((e) => {
        'id': e.id,
        'content': e.content,
        'createdAt': e.createdAt.toIso8601String(),
        'updatedAt': e.updatedAt.toIso8601String(),
      }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Restores all tables from a backup JSON string
  Future<bool> importBackupJson(String jsonStr) async {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map<String, dynamic>) return false;

      await db.transaction(() async {
        // Clear current data first
        await db.clearAllData();

        // Restore University
        if (decoded['university'] is List) {
          for (final item in decoded['university'] as List) {
            await db.into(db.universityEvents).insert(
              UniversityEventsCompanion.insert(
                id: item['id'],
                dayOfWeek: item['dayOfWeek'],
                startMinutes: item['startMinutes'],
                endMinutes: item['endMinutes'],
                subject: item['subject'],
                type: item['type'],
                location: Value(item['location']),
                instructor: Value(item['instructor']),
              ),
            );
          }
        }

        // Restore Calories
        if (decoded['calories'] is List) {
          for (final item in decoded['calories'] as List) {
            await db.into(db.calorieEntries).insert(
              CalorieEntriesCompanion.insert(
                id: item['id'],
                calories: item['calories'],
                note: Value(item['note']),
                createdAt: DateTime.parse(item['createdAt']),
              ),
            );
          }
        }

        // Restore Expenses
        if (decoded['expenses'] is List) {
          for (final item in decoded['expenses'] as List) {
            await db.into(db.expenseEntries).insert(
              ExpenseEntriesCompanion.insert(
                id: item['id'],
                amount: (item['amount'] as num).toDouble(),
                category: item['category'],
                type: Value(item['type'] as String? ?? 'expense'),
                note: Value(item['note']),
                createdAt: DateTime.parse(item['createdAt']),
              ),
            );
          }
        }

        // Restore Routines
        if (decoded['routines'] is List) {
          for (final item in decoded['routines'] as List) {
            await db.into(db.routines).insert(
              RoutinesCompanion.insert(
                id: item['id'],
                name: item['name'],
                icon: Value(item['icon']),
                preferredTime: Value(item['preferredTime']),
                isActive: Value(item['isActive'] ?? true),
                createdAt: DateTime.parse(item['createdAt']),
              ),
            );
          }
        }

        // Restore Completions
        if (decoded['routineCompletions'] is List) {
          for (final item in decoded['routineCompletions'] as List) {
            await db.into(db.routineCompletions).insert(
              RoutineCompletionsCompanion.insert(
                id: item['id'],
                routineId: item['routineId'],
                date: item['date'],
                completed: Value(item['completed'] ?? true),
                completedAt: DateTime.parse(item['completedAt']),
              ),
            );
          }
        }

        // Restore Todos
        if (decoded['todos'] is List) {
          for (final item in decoded['todos'] as List) {
            await db.into(db.todos).insert(
              TodosCompanion.insert(
                id: item['id'],
                title: item['title'],
                completed: Value(item['completed'] ?? false),
                createdAt: DateTime.parse(item['createdAt']),
                completedAt: Value(item['completedAt'] != null ? DateTime.parse(item['completedAt']) : null),
              ),
            );
          }
        }

        // Restore Notes
        if (decoded['notes'] is List) {
          for (final item in decoded['notes'] as List) {
            await db.into(db.notes).insert(
              NotesCompanion.insert(
                id: item['id'],
                content: item['content'],
                createdAt: DateTime.parse(item['createdAt']),
                updatedAt: DateTime.parse(item['updatedAt']),
              ),
            );
          }
        }
      });

      return true;
    } catch (_) {
      return false;
    }
  }
}
