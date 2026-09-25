import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/providers/theme_provider.dart';
import '../../../calories/presentation/add_calories_sheet.dart';
import '../../../expenses/presentation/add_expense_sheet.dart';
import '../../../notes/presentation/add_note_sheet.dart';
import '../../../routines/presentation/add_routine_sheet.dart';
import '../../../todos/presentation/add_todo_sheet.dart';

class QuickActionsBar extends ConsumerWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.border.withOpacity(theme.glass.borderOpacity),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickActionItem(
            label: loc.tr('calorie'),
            icon: LucideIcons.flame,
            color: colors.caloriesAccent,
            onTap: () {
              VibrationService.vibrateTick();
              AddCaloriesSheet.show(context);
            },
          ),
          _QuickActionItem(
            label: loc.tr('expense'),
            icon: LucideIcons.wallet,
            color: colors.expensesAccent,
            onTap: () {
              VibrationService.vibrateTick();
              AddExpenseSheet.show(context);
            },
          ),
          _QuickActionItem(
            label: loc.tr('routine'),
            icon: LucideIcons.checkCircle2,
            color: colors.routineAccent,
            onTap: () {
              VibrationService.vibrateTick();
              AddRoutineSheet.show(context);
            },
          ),
          _QuickActionItem(
            label: loc.tr('todo'),
            icon: LucideIcons.checkSquare,
            color: colors.todoAccent,
            onTap: () {
              VibrationService.vibrateTick();
              AddTodoSheet.show(context);
            },
          ),
          _QuickActionItem(
            label: loc.tr('note'),
            icon: LucideIcons.fileText,
            color: colors.notesAccent,
            onTap: () {
              VibrationService.vibrateTick();
              AddNoteSheet.show(context);
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              border: Border.all(
                color: color.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                if (theme.glow.enabled)
                  BoxShadow(
                    color: color.withOpacity(theme.glow.intensity * 0.25),
                    blurRadius: 10,
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, size: 20, color: color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.metadata.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
