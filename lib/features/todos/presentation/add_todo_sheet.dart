import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_sheet.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import '../../../services/obsidian_service.dart';

class AddTodoSheet extends ConsumerStatefulWidget {
  final Todo? existingTodo;

  const AddTodoSheet({super.key, this.existingTodo});

  static Future<void> show(BuildContext context, {Todo? todo}) {
    final loc = AppLocalizations.of(context);
    return GlassSheet.show(
      context: context,
      title: todo != null ? loc.tr('editTodo') : loc.tr('saveTodo'),
      child: AddTodoSheet(existingTodo: todo),
    );
  }

  @override
  ConsumerState<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends ConsumerState<AddTodoSheet> {
  late final TextEditingController _titleController;
  String? _errorText;
  final List<String> _selectedTags = [];

  static const List<String> _quickTags = [
    '#urgent',
    '#high',
    '#work',
    '#study',
    '#personal',
    '#errand',
  ];

  @override
  void initState() {
    super.initState();
    final initialTitle = widget.existingTodo?.title ?? '';
    _titleController = TextEditingController(text: initialTitle);

    // Extract tags if editing
    final tagRegex = RegExp(r'#(\w+)');
    for (final match in tagRegex.allMatches(initialTitle)) {
      final tag = match.group(0)!;
      if (!_selectedTags.contains(tag)) {
        _selectedTags.add(tag);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
        _titleController.text = _titleController.text.replaceAll(tag, '').replaceAll(RegExp(r'\s+'), ' ').trim();
      } else {
        _selectedTags.add(tag);
        final current = _titleController.text.trim();
        _titleController.text = current.isEmpty ? tag : '$current $tag';
      }
    });
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = loc.tr('enterName'));
      return;
    }

    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    if (widget.existingTodo != null) {
      // Update existing task
      await (db.update(db.todos)..where((t) => t.id.equals(widget.existingTodo!.id))).write(
        TodosCompanion(
          title: drift.Value(title),
        ),
      );
    } else {
      // Insert new task
      await db.into(db.todos).insert(
        TodosCompanion.insert(
          id: const Uuid().v4(),
          title: title,
          completed: const drift.Value(false),
          createdAt: now,
        ),
      );
    }

    // Auto-sync Obsidian daily file
    await ref.read(obsidianSyncProvider.notifier).syncToday();

    if (mounted) {
      Navigator.of(context).pop();
      final todayFileName = ObsidianService.getDailyFileName(now);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.tr('savedToObsidian', {'file': todayFileName}),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final obsidianState = ref.watch(obsidianSyncProvider);
    final targetFileName = ObsidianService.getDailyFileName(DateTime.now());
    final folderBasename = p.basename(obsidianState.vaultPath);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _titleController,
          hintText: 'Finish assignment, review lecture notes...',
          autofocus: true,
          onSubmitted: (_) => _save(),
          prefixIcon: Icon(LucideIcons.checkSquare, size: 18, color: colors.todoAccent),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorText!,
            style: AppTypography.metadata.copyWith(color: colors.danger),
          ),
        ],

        const SizedBox(height: 12),

        // Priority & Tag Chips
        Text(
          loc.tr('taskTags'),
          style: AppTypography.metadata.copyWith(color: colors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final tag in _quickTags) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (_) => _toggleTag(tag),
                    selectedColor: colors.todoAccent.withOpacity(0.25),
                    backgroundColor: colors.surfaceSecondary,
                    checkmarkColor: colors.todoAccent,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: _selectedTags.contains(tag) ? FontWeight.w700 : FontWeight.w500,
                      color: _selectedTags.contains(tag) ? colors.textPrimary : colors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: _selectedTags.contains(tag)
                            ? colors.todoAccent
                            : colors.border.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Path indicator line
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceSecondary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.folderCheck, size: 13, color: colors.todoAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  loc.tr('savingToDailyNote', {'file': '$folderBasename/$targetFileName'}),
                  style: TextStyle(fontSize: 10, color: colors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => ref.read(obsidianSyncProvider.notifier).pickFolder(),
                child: Text(
                  loc.tr('changeFolder'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.todoAccent,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: GlassButton(
                label: loc.tr('cancel'),
                isPrimary: false,
                height: 46,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassButton(
                label: loc.tr('save'),
                height: 46,
                onPressed: _save,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
