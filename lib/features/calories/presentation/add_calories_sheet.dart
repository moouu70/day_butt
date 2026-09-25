import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_sheet.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';

class AddCaloriesSheet extends ConsumerStatefulWidget {
  const AddCaloriesSheet({super.key});

  static Future<void> show(BuildContext context) {
    return GlassSheet.show(
      context: context,
      title: AppLocalizations.of(context).tr('addCalories'),
      child: const AddCaloriesSheet(),
    );
  }

  @override
  ConsumerState<AddCaloriesSheet> createState() => _AddCaloriesSheetState();
}

class _AddCaloriesSheetState extends ConsumerState<AddCaloriesSheet> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _caloriesController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final text = _caloriesController.text.trim();
    final calories = int.tryParse(text);

    if (calories == null || calories <= 0) {
      setState(() => _errorText = loc.tr('enterValidCalories'));
      return;
    }

    final db = ref.read(databaseProvider);
    final note = _noteController.text.trim();

    await db.into(db.calorieEntries).insert(
      CalorieEntriesCompanion.insert(
        id: const Uuid().v4(),
        calories: calories,
        note: drift.Value(note.isNotEmpty ? note : null),
        createdAt: DateTime.now(),
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
          controller: _caloriesController,
          hintText: '650',
          keyboardType: TextInputType.number,
          autofocus: true,
          suffix: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'kcal',
              style: AppTypography.metadata.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onSubmitted: (_) => _save(),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorText!,
            style: AppTypography.metadata.copyWith(color: colors.danger),
          ),
        ],
        const SizedBox(height: 12),
        AppTextField(
          controller: _noteController,
          hintText: '${loc.tr('calorieEntry')} (${loc.tr('optional')})',
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GlassButton(
                label: loc.tr('cancel'),
                isPrimary: false,
                height: 48,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassButton(
                label: loc.tr('save'),
                height: 48,
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
