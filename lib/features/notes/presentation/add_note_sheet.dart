import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_sheet.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';

class AddNoteSheet extends ConsumerStatefulWidget {
  const AddNoteSheet({super.key});

  static Future<void> show(BuildContext context) {
    return GlassSheet.show(
      context: context,
      title: AppLocalizations.of(context).tr('quickNote'),
      child: const AddNoteSheet(),
    );
  }

  @override
  ConsumerState<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends ConsumerState<AddNoteSheet> {
  final TextEditingController _contentController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() => _errorText = loc.tr('enterContent'));
      return;
    }

    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    await db.into(db.notes).insert(
      NotesCompanion.insert(
        id: const Uuid().v4(),
        content: content,
        createdAt: now,
        updatedAt: now,
      ),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _contentController,
          hintText: loc.tr('captureThought'),
          maxLines: 4,
          autofocus: true,
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorText!,
            style: AppTypography.metadata.copyWith(color: colors.danger),
          ),
        ],
        const SizedBox(height: 20),
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
