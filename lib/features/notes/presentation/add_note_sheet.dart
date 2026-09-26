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

class AddNoteSheet extends ConsumerStatefulWidget {
  final Note? existingNote;

  const AddNoteSheet({super.key, this.existingNote});

  static Future<void> show(BuildContext context, {Note? note}) {
    final loc = AppLocalizations.of(context);
    return GlassSheet.show(
      context: context,
      title: note != null ? loc.tr('editNote') : loc.tr('quickNote'),
      child: AddNoteSheet(existingNote: note),
    );
  }

  @override
  ConsumerState<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends ConsumerState<AddNoteSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _isPreviewMode = false;
  String? _errorText;
  final List<String> _selectedTags = [];

  static const List<String> _suggestedTags = [
    '#idea',
    '#study',
    '#work',
    '#personal',
    '#todo',
    '#meeting',
    '#important',
  ];

  @override
  void initState() {
    super.initState();
    String initialTitle = '';
    String initialContent = widget.existingNote?.content ?? '';

    // If editing existing note, check if first line is a markdown title
    if (widget.existingNote != null && initialContent.isNotEmpty) {
      final lines = initialContent.split('\n');
      if (lines.first.startsWith('# ')) {
        initialTitle = lines.first.substring(2).trim();
        initialContent = lines.skip(1).join('\n').trim();
      }

      // Extract existing tags
      final tagRegex = RegExp(r'#(\w+)');
      for (final match in tagRegex.allMatches(widget.existingNote!.content)) {
        final tag = match.group(0)!;
        if (!_selectedTags.contains(tag)) {
          _selectedTags.add(tag);
        }
      }
    }

    _titleController = TextEditingController(text: initialTitle);
    _contentController = TextEditingController(text: initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _insertMarkdown(String prefix, [String suffix = '']) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    if (selection.start < 0 || selection.end < 0) {
      _contentController.text = '$text$prefix$suffix';
      _contentController.selection = TextSelection.collapsed(offset: _contentController.text.length);
      return;
    }

    final selectedText = text.substring(selection.start, selection.end);
    final replacement = '$prefix$selectedText$suffix';
    final newText = text.replaceRange(selection.start, selection.end, replacement);
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: selection.start + prefix.length + selectedText.length,
    );
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
        // Remove from content if present
        _contentController.text = _contentController.text.replaceAll(tag, '').trim();
      } else {
        _selectedTags.add(tag);
        // Append tag to content
        final current = _contentController.text.trim();
        _contentController.text = current.isEmpty ? tag : '$current $tag';
      }
    });
  }

  String _assembleFinalContent() {
    final title = _titleController.text.trim();
    final body = _contentController.text.trim();

    final buffer = StringBuffer();
    if (title.isNotEmpty) {
      buffer.writeln('# $title');
      buffer.writeln();
    }
    buffer.write(body);

    return buffer.toString().trim();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final finalContent = _assembleFinalContent();
    if (finalContent.isEmpty) {
      setState(() => _errorText = loc.tr('enterContent'));
      return;
    }

    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    if (widget.existingNote != null) {
      // Update existing note
      await (db.update(db.notes)..where((n) => n.id.equals(widget.existingNote!.id))).write(
        NotesCompanion(
          content: driftValue(finalContent),
          updatedAt: driftValue(now),
        ),
      );
    } else {
      // Insert new note
      await db.into(db.notes).insert(
        NotesCompanion.insert(
          id: const Uuid().v4(),
          content: finalContent,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    // Automatically sync Obsidian daily note file
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
        // Mode Switcher (Write vs Obsidian Preview)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isPreviewMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: !_isPreviewMode ? colors.primary.withOpacity(0.28) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: !_isPreviewMode ? Border.all(color: colors.primary) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.penTool, size: 13, color: !_isPreviewMode ? colors.primary : colors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            loc.tr('editTab'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: !_isPreviewMode ? FontWeight.w700 : FontWeight.w500,
                              color: !_isPreviewMode ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isPreviewMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isPreviewMode ? colors.notesAccent.withOpacity(0.28) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: _isPreviewMode ? Border.all(color: colors.notesAccent) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.eye, size: 13, color: _isPreviewMode ? colors.notesAccent : colors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            loc.tr('previewTab'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _isPreviewMode ? FontWeight.w700 : FontWeight.w500,
                              color: _isPreviewMode ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Obsidian status badge
            InkWell(
              onTap: () async {
                await ref.read(obsidianSyncProvider.notifier).pickFolder();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.folder, size: 13, color: colors.notesAccent),
                    const SizedBox(width: 4),
                    Text(
                      targetFileName,
                      style: AppTypography.metadata.copyWith(
                        fontSize: 11,
                        color: colors.notesAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (!_isPreviewMode) ...[
          // Title Input (Optional)
          AppTextField(
            controller: _titleController,
            hintText: loc.tr('noteTitleOptional'),
            prefixIcon: Icon(LucideIcons.heading, size: 16, color: colors.textMuted),
          ),

          const SizedBox(height: 10),

          // Content Input
          AppTextField(
            controller: _contentController,
            hintText: loc.tr('captureThought'),
            maxLines: 5,
            autofocus: widget.existingNote == null,
          ),

          const SizedBox(height: 10),

          // Markdown formatting toolbar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildToolbarButton(
                  icon: LucideIcons.heading2,
                  tooltip: 'Heading',
                  onTap: () => _insertMarkdown('## '),
                  colors: colors,
                ),
                const SizedBox(width: 6),
                _buildToolbarButton(
                  icon: LucideIcons.bold,
                  tooltip: 'Bold',
                  onTap: () => _insertMarkdown('**', '**'),
                  colors: colors,
                ),
                const SizedBox(width: 6),
                _buildToolbarButton(
                  icon: LucideIcons.italic,
                  tooltip: 'Italic',
                  onTap: () => _insertMarkdown('*', '*'),
                  colors: colors,
                ),
                const SizedBox(width: 6),
                _buildToolbarButton(
                  icon: LucideIcons.checkSquare,
                  tooltip: 'Task Checkbox',
                  onTap: () => _insertMarkdown('- [ ] '),
                  colors: colors,
                ),
                const SizedBox(width: 6),
                _buildToolbarButton(
                  icon: LucideIcons.list,
                  tooltip: 'Bullet List',
                  onTap: () => _insertMarkdown('- '),
                  colors: colors,
                ),
                const SizedBox(width: 6),
                _buildToolbarButton(
                  icon: LucideIcons.quote,
                  tooltip: 'Obsidian Callout',
                  onTap: () => _insertMarkdown('> [!note] \n> '),
                  colors: colors,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Suggested Tag Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final tag in _suggestedTags) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (_) => _toggleTag(tag),
                      selectedColor: colors.notesAccent.withOpacity(0.25),
                      backgroundColor: colors.surfaceSecondary,
                      checkmarkColor: colors.notesAccent,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: _selectedTags.contains(tag) ? FontWeight.w700 : FontWeight.w500,
                        color: _selectedTags.contains(tag) ? colors.textPrimary : colors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: _selectedTags.contains(tag)
                              ? colors.notesAccent
                              : colors.border.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          // Obsidian Preview View
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(minHeight: 180, maxHeight: 280),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.notesAccent.withOpacity(0.3)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Callout header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.notesAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.notesAccent.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.fileText, size: 16, color: colors.notesAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _titleController.text.trim().isNotEmpty
                                    ? _titleController.text.trim()
                                    : 'Obsidian Callout Preview',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _contentController.text.trim().isNotEmpty
                              ? _contentController.text.trim()
                              : 'Your note markdown content will appear here inside the daily note callout.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '📄 Target daily file: $targetFileName',
                    style: AppTypography.metadata.copyWith(
                      color: colors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorText!,
            style: AppTypography.metadata.copyWith(color: colors.danger),
          ),
        ],

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
              Icon(LucideIcons.folderCheck, size: 13, color: colors.notesAccent),
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
                    color: colors.notesAccent,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Action Buttons
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

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required dynamic colors,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: colors.surfaceSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: Icon(icon, size: 14, color: colors.textSecondary),
        ),
      ),
    );
  }
}

// Drift value helper
drift.Value<T> driftValue<T>(T val) {
  return drift.Value(val);
}
