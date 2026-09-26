import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_butt/database/app_database.dart';
import 'package:day_butt/services/obsidian_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Obsidian Daily Notes Service Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('getDailyFileName returns YYYY-MM-DD.md format', () {
      final date = DateTime(2026, 9, 26);
      final fileName = ObsidianService.getDailyFileName(date);
      expect(fileName, '2026-09-26.md');
    });

    test('generateObsidianMarkdown produces Obsidian-compatible format with frontmatter and callouts', () {
      final date = DateTime(2026, 9, 26, 14, 30);
      final todos = [
        Todo(
          id: '1',
          title: 'Finish biology report #study',
          completed: false,
          createdAt: DateTime(2026, 9, 26, 9, 0),
        ),
        Todo(
          id: '2',
          title: 'Buy groceries #errands',
          completed: true,
          createdAt: DateTime(2026, 9, 26, 10, 0),
          completedAt: DateTime(2026, 9, 26, 11, 15),
        ),
      ];

      final notes = [
        Note(
          id: 'n1',
          content: '# Meeting Notes\nDiscussed graduation project roadmap.\n#work #university',
          createdAt: DateTime(2026, 9, 26, 14, 0),
          updatedAt: DateTime(2026, 9, 26, 14, 0),
        ),
      ];

      final markdown = ObsidianService.generateObsidianMarkdown(
        date: date,
        todos: todos,
        notes: notes,
      );

      // Verify YAML Frontmatter
      expect(markdown.contains('---'), isTrue);
      expect(markdown.contains('title: "2026-09-26"'), isTrue);
      expect(markdown.contains('date: 2026-09-26'), isTrue);
      expect(markdown.contains('tags:'), isTrue);
      expect(markdown.contains('- daily-note'), isTrue);
      expect(markdown.contains('- daybutt'), isTrue);
      expect(markdown.contains('total_tasks: 2'), isTrue);
      expect(markdown.contains('completed_tasks: 1'), isTrue);

      // Verify Obsidian Callouts
      expect(markdown.contains('> [!summary] 📊 Daily Overview'), isTrue);
      expect(markdown.contains('> - **Tasks:** 1 / 2 completed (50%)'), isTrue);

      // Verify Tasks format
      expect(markdown.contains('## ✅ Tasks'), isTrue);
      expect(markdown.contains('- [ ] Finish biology report #study'), isTrue);
      expect(markdown.contains('- [x] Buy groceries #errands *(completed at 11:15 AM)*'), isTrue);

      // Verify Notes format
      expect(markdown.contains('## 📝 Notes'), isTrue);
      expect(markdown.contains('> [!note] Meeting Notes'), isTrue);
      expect(markdown.contains('> Discussed graduation project roadmap.'), isTrue);
    });

    test('Custom vault path configuration in SharedPreferences', () async {
      final tempDir = Directory.systemTemp.createTempSync('obsidian_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final success = await ObsidianService.setCustomPath(tempDir.path);
      expect(success, isTrue);

      final isCustom = await ObsidianService.isCustomPathConfigured();
      expect(isCustom, isTrue);

      final activePath = await ObsidianService.getActivePath();
      expect(activePath, tempDir.path);

      // Reset to default
      await ObsidianService.resetToDefaultPath();
      final isCustomAfterReset = await ObsidianService.isCustomPathConfigured();
      expect(isCustomAfterReset, isFalse);
    });

    test('Auto-sync toggle preferences', () async {
      expect(await ObsidianService.isAutoSyncEnabled(), isTrue);

      await ObsidianService.setAutoSync(false);
      expect(await ObsidianService.isAutoSyncEnabled(), isFalse);

      await ObsidianService.setAutoSync(true);
      expect(await ObsidianService.isAutoSyncEnabled(), isTrue);
    });

    test('Writing daily file saves correctly to directory', () async {
      final tempDir = Directory.systemTemp.createTempSync('obsidian_file_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      await ObsidianService.setCustomPath(tempDir.path);

      final date = DateTime(2026, 9, 26);
      final file = await ObsidianService.writeDailyFile(
        date: date,
        todos: [
          Todo(
            id: 't1',
            title: 'Sample task',
            completed: false,
            createdAt: date,
          ),
        ],
        notes: [
          Note(
            id: 'n1',
            content: 'Sample note content',
            createdAt: date,
            updatedAt: date,
          ),
        ],
      );

      expect(await file.exists(), isTrue);
      expect(file.path.endsWith('2026-09-26.md'), isTrue);

      final content = await file.readAsString();
      expect(content.contains('- [ ] Sample task'), isTrue);
      expect(content.contains('Sample note content'), isTrue);
    });

    test('parseDailyMarkdown extracts tasks, checked status, and notes accurately', () {
      const markdown = '''
---
title: "2026-09-26"
date: 2026-09-26
---

# 📅 Saturday, September 26, 2026

## ✅ Tasks
- [ ] Read research paper #study
- [x] Submit homework #urgent *(completed at 10:30 AM)*
- [x] Buy coffee

## 📝 Notes
### 🕒 11:00 AM — Project Brainstorm
> [!note] Project Brainstorm
> Discussed UI redesign with team.
> #meeting

### Quick idea
Remember to check exam schedule.

---
*Synced with Daybutt • 2026-09-26 12:00*
''';

      final parsed = ObsidianService.parseDailyMarkdown(
        defaultDate: DateTime(2026, 9, 26),
        markdown: markdown,
      );

      expect(parsed.todos.length, 3);
      expect(parsed.todos[0].title, 'Read research paper #study');
      expect(parsed.todos[0].completed, isFalse);

      expect(parsed.todos[1].title, 'Submit homework #urgent');
      expect(parsed.todos[1].completed, isTrue);

      expect(parsed.todos[2].title, 'Buy coffee');
      expect(parsed.todos[2].completed, isTrue);

      expect(parsed.notes.length, 2);
      expect(parsed.notes[0].content.contains('Discussed UI redesign with team.'), isTrue);
      expect(parsed.notes[1].content.contains('Remember to check exam schedule.'), isTrue);
    });

    test('importFromMarkdown updates SQLite database reflecting markdown edits', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());

      final date = DateTime(2026, 9, 26, 10, 0);

      // 1. Pre-populate SQLite with an uncompleted task
      await db.into(db.todos).insert(
        TodosCompanion.insert(
          id: 'todo_initial',
          title: 'Read chapter 3',
          completed: const drift.Value(false),
          createdAt: date,
        ),
      );

      // Verify initial state
      var todos = await db.select(db.todos).get();
      expect(todos.length, 1);
      expect(todos.first.completed, isFalse);

      // 2. Simulate Obsidian user checking the task AND adding a new task
      const updatedMarkdown = '''
---
date: 2026-09-26
---

# 📅 Daily Note

## ✅ Tasks
- [x] Read chapter 3
- [ ] Prepare presentation slides #work

## 📝 Notes
### 🕒 02:00 PM — New Note
> [!note] New Note
> Added directly from Obsidian!
''';

      final success = await ObsidianService.importFromMarkdown(
        date: date,
        markdown: updatedMarkdown,
        db: db,
      );
      expect(success, isTrue);

      // Verify SQLite updated
      todos = await db.select(db.todos).get();
      expect(todos.length, 2);

      final task1 = todos.firstWhere((t) => t.title == 'Read chapter 3');
      expect(task1.completed, isTrue); // Now marked completed!

      final task2 = todos.firstWhere((t) => t.title.contains('Prepare presentation slides'));
      expect(task2.completed, isFalse); // Newly imported!

      // Verify Note imported
      final notes = await db.select(db.notes).get();
      expect(notes.length, 1);
      expect(notes.first.content.contains('Added directly from Obsidian!'), isTrue);
    });
  });
}

