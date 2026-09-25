import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_sheet.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import '../data/routine_suggestions.dart';

class AddRoutineSheet extends ConsumerStatefulWidget {
  final String? initialName;
  final String? initialTime;

  const AddRoutineSheet({
    super.key,
    this.initialName,
    this.initialTime,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialName,
    String? initialTime,
  }) {
    return GlassSheet.show(
      context: context,
      title: AppLocalizations.of(context).tr('createRoutine'),
      child: AddRoutineSheet(
        initialName: initialName,
        initialTime: initialTime,
      ),
    );
  }

  @override
  ConsumerState<AddRoutineSheet> createState() => _AddRoutineSheetState();
}

class _AddRoutineSheetState extends ConsumerState<AddRoutineSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _timeController = TextEditingController(text: widget.initialTime ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = loc.tr('enterName'));
      return;
    }

    final db = ref.read(databaseProvider);
    final time = _timeController.text.trim();
    final existing = await (db.select(db.routines)..where((t) => t.isActive.equals(true))).get();
    final nextOrder = existing.length;

    await db.into(db.routines).insert(
      RoutinesCompanion.insert(
        id: const Uuid().v4(),
        name: name,
        preferredTime: drift.Value(time.isNotEmpty ? time : null),
        isActive: const drift.Value(true),
        sortOrder: drift.Value(nextOrder),
        createdAt: DateTime.now(),
      ),
    );

    VibrationService.vibrateTick();
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
          controller: _nameController,
          hintText: loc.isArabic ? 'مثال: أذكار الصباح، ورد القراءة...' : 'Study 2 hours, Workout...',
          labelText: loc.tr('routine'),
          autofocus: widget.initialName == null,
          onSubmitted: (_) => _save(),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorText!,
            style: AppTypography.metadata.copyWith(color: colors.danger),
          ),
        ],

        const SizedBox(height: 14),

        // Suggestions
        Row(
          children: [
            Icon(LucideIcons.sparkles, size: 12, color: colors.routineAccent),
            const SizedBox(width: 5),
            Text(
              loc.tr('suggestions'),
              style: AppTypography.labelUppercase.copyWith(
                fontSize: 11,
                letterSpacing: 1.2,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kRoutineSuggestions.map((suggestion) {
            final title = suggestion.getTitle(loc.isArabic);
            final isSelected = _nameController.text.trim() == title;

            return InkWell(
              onTap: () {
                VibrationService.vibrateTick();
                setState(() {
                  _nameController.text = title;
                  if (suggestion.preferredTime != null) {
                    _timeController.text = suggestion.preferredTime!;
                  }
                  _errorText = null;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.routineAccent.withOpacity(0.2)
                      : colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? colors.routineAccent
                        : colors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      suggestion.icon,
                      size: 13,
                      color: isSelected
                          ? colors.routineAccent
                          : colors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: AppTypography.metadata.copyWith(
                        color: isSelected
                            ? colors.routineAccent
                            : colors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),
        AppTextField(
          controller: _timeController,
          hintText: '08:00 AM (${loc.tr('optional')})',
          labelText: loc.isArabic ? 'الوقت المفضل' : 'Preferred time',
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GlassButton(
                label: loc.tr('cancel'),
                isPrimary: false,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassButton(
                label: loc.tr('save'),
                onPressed: _save,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

