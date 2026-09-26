import 'dart:io';
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
  });
}
