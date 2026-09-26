import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../core/utils/date_utils.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class ObsidianSyncState {
  final String vaultPath;
  final bool isCustomPath;
  final bool autoSync;
  final DateTime? lastSyncedAt;
  final bool isSyncing;
  final String? lastError;

  const ObsidianSyncState({
    required this.vaultPath,
    required this.isCustomPath,
    required this.autoSync,
    this.lastSyncedAt,
    this.isSyncing = false,
    this.lastError,
  });

  ObsidianSyncState copyWith({
    String? vaultPath,
    bool? isCustomPath,
    bool? autoSync,
    DateTime? lastSyncedAt,
    bool? isSyncing,
    String? lastError,
  }) {
    return ObsidianSyncState(
      vaultPath: vaultPath ?? this.vaultPath,
      isCustomPath: isCustomPath ?? this.isCustomPath,
      autoSync: autoSync ?? this.autoSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isSyncing: isSyncing ?? this.isSyncing,
      lastError: lastError,
    );
  }
}

class ObsidianService {
  static const String _prefVaultPathKey = 'obsidian_vault_path';
  static const String _prefAutoSyncKey = 'obsidian_auto_sync';
  static const String _defaultSubdir = 'Daybutt_Daily_Notes';

  /// Get the default fallback directory
  static Future<String> getDefaultDirectory() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final defaultDir = Directory(p.join(docDir.path, _defaultSubdir));
      if (!await defaultDir.exists()) {
        await defaultDir.create(recursive: true);
      }
      return defaultDir.path;
    } catch (e) {
      debugPrint('Error getting default Obsidian directory: $e');
      return '/tmp/Daybutt_Daily_Notes';
    }
  }

  /// Get currently active vault path
  static Future<String> getActivePath() async {
    final prefs = await SharedPreferences.getInstance();
    final customPath = prefs.getString(_prefVaultPathKey);
    if (customPath != null && customPath.trim().isNotEmpty) {
      final dir = Directory(customPath.trim());
      if (await dir.exists()) {
        return dir.path;
      }
    }
    return getDefaultDirectory();
  }

  /// Check whether user configured a custom path
  static Future<bool> isCustomPathConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    final custom = prefs.getString(_prefVaultPathKey);
    return custom != null && custom.trim().isNotEmpty;
  }

  /// Pick directory using FilePicker
  static Future<String?> pickVaultDirectory() async {
    try {
      final selectedDirectory = await FilePicker.getDirectoryPath(
        dialogTitle: 'Select Obsidian Vault / Daily Notes Folder',
      );

      if (selectedDirectory != null && selectedDirectory.trim().isNotEmpty) {
        final path = selectedDirectory.trim();
        final success = await setCustomPath(path);
        if (success) {
          return path;
        }
      }
    } catch (e) {
      debugPrint('Error picking directory with FilePicker: $e');
    }
    return null;
  }

  /// Set custom directory manually or from picker
  static Future<bool> setCustomPath(String path) async {
    try {
      final dir = Directory(path.trim());
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Verify write permission
      final testFile = File(p.join(dir.path, '.daybutt_write_test'));
      await testFile.writeAsString('ok');
      await testFile.delete();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefVaultPathKey, dir.path);
      return true;
    } catch (e) {
      debugPrint('Failed to set Obsidian path: $e');
      return false;
    }
  }

  /// Reset to default storage path
  static Future<void> resetToDefaultPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefVaultPathKey);
  }

  /// Auto sync getter & setter
  static Future<bool> isAutoSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefAutoSyncKey) ?? true;
  }

  static Future<void> setAutoSync(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefAutoSyncKey, enabled);
  }

  /// Get file name for a given date (standard Obsidian Daily Note format: YYYY-MM-DD.md)
  static String getDailyFileName(DateTime date) {
    return '${DateFormat('yyyy-MM-dd').format(date)}.md';
  }

  /// Get the full target file for a given date
  static Future<File> getDailyFile(DateTime date) async {
    final folder = await getActivePath();
    final fileName = getDailyFileName(date);
    return File(p.join(folder, fileName));
  }

  /// Format day's content as a clean, Obsidian-ready Markdown document
  static String generateObsidianMarkdown({
    required DateTime date,
    required List<Todo> todos,
    required List<Note> notes,
  }) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final dayNameEn = DateFormat('EEEE').format(date);
    final formattedDateTitle = DateFormat('EEEE, MMMM d, yyyy').format(date);
    final completedCount = todos.where((t) => t.completed).length;
    final totalTasks = todos.length;
    final totalNotes = notes.length;
    final completionPct = totalTasks > 0 ? ((completedCount / totalTasks) * 100).round() : 0;

    final buffer = StringBuffer();

    // 1. Obsidian Frontmatter (YAML Properties)
    buffer.writeln('---');
    buffer.writeln('title: "$dateKey"');
    buffer.writeln('date: $dateKey');
    buffer.writeln('day: $dayNameEn');
    buffer.writeln('tags:');
    buffer.writeln('  - daily-note');
    buffer.writeln('  - daybutt');
    buffer.writeln('total_tasks: $totalTasks');
    buffer.writeln('completed_tasks: $completedCount');
    buffer.writeln('completion_rate: "$completionPct%"');
    buffer.writeln('total_notes: $totalNotes');
    buffer.writeln('---');
    buffer.writeln();

    // 2. Document Title
    buffer.writeln('# 📅 $formattedDateTitle');
    buffer.writeln();

    // 3. Obsidian Callout: Daily Overview
    buffer.writeln('> [!summary] 📊 Daily Overview');
    if (totalTasks == 0 && totalNotes == 0) {
      buffer.writeln('> No tasks or notes recorded yet for this day.');
    } else {
      buffer.writeln('> - **Tasks:** $completedCount / $totalTasks completed ($completionPct%)');
      buffer.writeln('> - **Notes:** $totalNotes captured');
    }
    buffer.writeln();

    // 4. Tasks Section
    buffer.writeln('## ✅ Tasks');
    if (todos.isEmpty) {
      buffer.writeln('_No tasks for today._');
    } else {
      for (final todo in todos) {
        final mark = todo.completed ? 'x' : ' ';
        final timeSuffix = todo.completed && todo.completedAt != null
            ? ' *(completed at ${DateFormat('hh:mm a').format(todo.completedAt!)})*'
            : '';
        buffer.writeln('- [$mark] ${todo.title}$timeSuffix');
      }
    }
    buffer.writeln();

    // 5. Notes Section
    buffer.writeln('## 📝 Notes');
    if (notes.isEmpty) {
      buffer.writeln('_No notes recorded for today._');
    } else {
      for (var i = 0; i < notes.length; i++) {
        final note = notes[i];
        final timeStr = DateFormat('hh:mm a').format(note.createdAt);
        final lines = note.content.trim().split('\n');

        // Extract title if first line looks like a title or header
        String noteTitle;
        List<String> contentLines;
        if (lines.first.startsWith('#')) {
          noteTitle = lines.first.replaceAll(RegExp(r'^#+\s*'), '').trim();
          contentLines = lines.skip(1).toList();
        } else if (lines.length > 1 && lines.first.length <= 60 && !lines.first.contains('.')) {
          noteTitle = lines.first.trim();
          contentLines = lines.skip(1).toList();
        } else {
          noteTitle = 'Note ${i + 1} ($timeStr)';
          contentLines = lines;
        }

        buffer.writeln('### 🕒 $timeStr — $noteTitle');
        buffer.writeln('> [!note] $noteTitle');

        // Indent lines inside Obsidian callout
        for (final line in contentLines) {
          if (line.trim().isEmpty) {
            buffer.writeln('>');
          } else {
            buffer.writeln('> $line');
          }
        }
        buffer.writeln();
      }
    }

    // 6. Footer
    buffer.writeln('---');
    final nowFormatted = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    buffer.writeln('*Synced with Daybutt • $nowFormatted*');

    return buffer.toString();
  }

  /// Sync today's tasks and notes to the daily file
  static Future<File?> syncToday(AppDatabase db, {bool force = false}) async {
    final autoSync = await isAutoSyncEnabled();
    if (!autoSync && !force) return null;

    try {
      final now = DateTime.now();
      final start = AppDateUtils.startOfDay(now);
      final end = AppDateUtils.endOfDay(now);

      // Get all tasks and notes for today
      final allTodos = await db.select(db.todos).get();
      final todayTodos = allTodos.where((t) {
        return t.createdAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
            t.createdAt.isBefore(end.add(const Duration(seconds: 1)));
      }).toList();

      // If no todos specifically created today, include non-completed todos as active today
      final effectiveTodos = todayTodos.isNotEmpty
          ? todayTodos
          : allTodos.where((t) => !t.completed).toList();

      // For notes, take notes created or updated today
      final allNotes = await db.select(db.notes).get();
      final todayNotes = allNotes.where((n) {
        return (n.createdAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
                n.createdAt.isBefore(end.add(const Duration(seconds: 1)))) ||
            (n.updatedAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
                n.updatedAt.isBefore(end.add(const Duration(seconds: 1))));
      }).toList();

      return await writeDailyFile(
        date: now,
        todos: effectiveTodos,
        notes: todayNotes,
      );
    } catch (e) {
      debugPrint('Error syncing today to Obsidian: $e');
      return null;
    }
  }

  /// Write daily file for given date with provided todos and notes
  static Future<File> writeDailyFile({
    required DateTime date,
    required List<Todo> todos,
    required List<Note> notes,
  }) async {
    final file = await getDailyFile(date);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    final markdown = generateObsidianMarkdown(
      date: date,
      todos: todos,
      notes: notes,
    );

    await file.writeAsString(markdown, flush: true);
    debugPrint('Obsidian daily note written to: ${file.path}');
    return file;
  }

  /// Export all historical days into Obsidian files
  static Future<int> syncAllDays(AppDatabase db) async {
    final allTodos = await db.select(db.todos).get();
    final allNotes = await db.select(db.notes).get();

    // Group dates
    final Set<String> dayKeys = {};
    for (final t in allTodos) {
      dayKeys.add(AppDateUtils.toDateKey(t.createdAt));
    }
    for (final n in allNotes) {
      dayKeys.add(AppDateUtils.toDateKey(n.createdAt));
    }

    // Always include today
    dayKeys.add(AppDateUtils.toDateKey(DateTime.now()));

    int syncedCount = 0;
    for (final key in dayKeys) {
      DateTime? date;
      try {
        date = DateFormat('yyyy-MM-dd').parse(key);
      } catch (_) {
        continue;
      }

      final dayTodos = allTodos.where((t) {
        return AppDateUtils.toDateKey(t.createdAt) == key;
      }).toList();

      final dayNotes = allNotes.where((n) {
        return AppDateUtils.toDateKey(n.createdAt) == key ||
            AppDateUtils.toDateKey(n.updatedAt) == key;
      }).toList();

      await writeDailyFile(
        date: date,
        todos: dayTodos,
        notes: dayNotes,
      );
      syncedCount++;
    }

    return syncedCount;
  }

  /// Read today's markdown preview
  static Future<String> getTodayPreviewContent(AppDatabase db) async {
    final now = DateTime.now();
    final start = AppDateUtils.startOfDay(now);
    final end = AppDateUtils.endOfDay(now);

    final allTodos = await db.select(db.todos).get();
    final todayTodos = allTodos.where((t) {
      return t.createdAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
          t.createdAt.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();
    final effectiveTodos = todayTodos.isNotEmpty ? todayTodos : allTodos.where((t) => !t.completed).toList();

    final allNotes = await db.select(db.notes).get();
    final todayNotes = allNotes.where((n) {
      return (n.createdAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
              n.createdAt.isBefore(end.add(const Duration(seconds: 1)))) ||
          (n.updatedAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
              n.updatedAt.isBefore(end.add(const Duration(seconds: 1))));
    }).toList();

    return generateObsidianMarkdown(
      date: now,
      todos: effectiveTodos,
      notes: todayNotes,
    );
  }
}

/// Riverpod Notifier for Obsidian Settings
class ObsidianSyncNotifier extends Notifier<ObsidianSyncState> {
  @override
  ObsidianSyncState build() {
    _loadSettings();
    return const ObsidianSyncState(
      vaultPath: '',
      isCustomPath: false,
      autoSync: true,
    );
  }

  Future<void> _loadSettings() async {
    final path = await ObsidianService.getActivePath();
    final isCustom = await ObsidianService.isCustomPathConfigured();
    final auto = await ObsidianService.isAutoSyncEnabled();
    state = state.copyWith(
      vaultPath: path,
      isCustomPath: isCustom,
      autoSync: auto,
    );
  }

  Future<bool> pickFolder() async {
    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final newPath = await ObsidianService.pickVaultDirectory();
      if (newPath != null) {
        state = state.copyWith(
          vaultPath: newPath,
          isCustomPath: true,
          isSyncing: false,
        );
        // Automatically sync today's note upon setting path
        await syncToday();
        return true;
      }
    } catch (e) {
      state = state.copyWith(lastError: e.toString());
    } finally {
      state = state.copyWith(isSyncing: false);
    }
    return false;
  }

  Future<bool> setCustomPath(String path) async {
    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final success = await ObsidianService.setCustomPath(path);
      if (success) {
        state = state.copyWith(
          vaultPath: path,
          isCustomPath: true,
          isSyncing: false,
        );
        await syncToday();
        return true;
      } else {
        state = state.copyWith(lastError: 'Folder is not writable or cannot be created');
      }
    } catch (e) {
      state = state.copyWith(lastError: e.toString());
    } finally {
      state = state.copyWith(isSyncing: false);
    }
    return false;
  }

  Future<void> resetToDefault() async {
    await ObsidianService.resetToDefaultPath();
    await _loadSettings();
  }

  Future<void> toggleAutoSync(bool value) async {
    await ObsidianService.setAutoSync(value);
    state = state.copyWith(autoSync: value);
  }

  Future<bool> syncToday() async {
    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final db = ref.read(databaseProvider);
      final file = await ObsidianService.syncToday(db, force: true);
      state = state.copyWith(
        lastSyncedAt: DateTime.now(),
        isSyncing: false,
      );
      return file != null;
    } catch (e) {
      state = state.copyWith(isSyncing: false, lastError: e.toString());
      return false;
    }
  }

  Future<int> syncAllDays() async {
    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final db = ref.read(databaseProvider);
      final count = await ObsidianService.syncAllDays(db);
      state = state.copyWith(
        lastSyncedAt: DateTime.now(),
        isSyncing: false,
      );
      return count;
    } catch (e) {
      state = state.copyWith(isSyncing: false, lastError: e.toString());
      return 0;
    }
  }
}

final obsidianSyncProvider = NotifierProvider<ObsidianSyncNotifier, ObsidianSyncState>(() {
  return ObsidianSyncNotifier();
});
