import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/calorie_goal_provider.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/providers/theme_provider.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_sheet.dart';

class EditCalorieGoalSheet extends ConsumerStatefulWidget {
  const EditCalorieGoalSheet({super.key});

  static Future<void> show(BuildContext context) {
    return GlassSheet.show(
      context: context,
      title: AppLocalizations.of(context).tr('editDailyGoal'),
      child: const EditCalorieGoalSheet(),
    );
  }

  @override
  ConsumerState<EditCalorieGoalSheet> createState() => _EditCalorieGoalSheetState();
}

class _EditCalorieGoalSheetState extends ConsumerState<EditCalorieGoalSheet> {
  late final TextEditingController _controller;
  String? _errorText;
  static const List<int> _presetGoals = [1800, 2000, 2200, 2300, 2500, 3000];

  @override
  void initState() {
    super.initState();
    final currentGoal = ref.read(calorieGoalProvider);
    _controller = TextEditingController(text: currentGoal.toString());
    _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final theme = ref.read(effectiveThemeProvider);
    final colors = theme.colors;
    final text = _controller.text.trim();
    final goal = int.tryParse(text);

    if (goal == null || goal <= 0) {
      setState(() => _errorText = loc.tr('invalidGoal'));
      return;
    }

    VibrationService.vibratePress();
    await ref.read(calorieGoalProvider.notifier).setCalorieGoal(goal);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(LucideIcons.check, color: colors.success, size: 18),
              const SizedBox(width: 8),
              Text(loc.tr('goalUpdated')),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.surface,
        ),
      );
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
        Text(
          loc.tr('calorieGoalHint'),
          style: AppTypography.bodyMuted.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _controller,
          hintText: '2300',
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
        const SizedBox(height: 16),
        Text(
          loc.tr('quickPresets'),
          style: AppTypography.labelUppercase.copyWith(
            fontSize: 11,
            letterSpacing: 1.2,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetGoals.map((preset) {
            final isSelected = _controller.text == preset.toString();
            return InkWell(
              onTap: () {
                VibrationService.vibrateTick();
                setState(() {
                  _controller.text = preset.toString();
                  _errorText = null;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.caloriesAccent.withOpacity(0.2)
                      : colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colors.caloriesAccent
                        : colors.border.withOpacity(0.15),
                  ),
                ),
                child: Text(
                  '$preset kcal',
                  style: AppTypography.metadata.copyWith(
                    color: isSelected ? colors.caloriesAccent : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        GlassButton(
          label: loc.tr('save'),
          onPressed: _save,
          height: 48,
        ),
      ],
    );
  }
}
