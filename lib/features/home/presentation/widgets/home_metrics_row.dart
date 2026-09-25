import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/providers/theme_provider.dart';
import '../../../../core/utils/currency_formatter.dart';

class HomeMetricsRow extends ConsumerWidget {
  final int completedRoutines;
  final int totalRoutines;
  final int todayCalories;
  final double todayExpenses;
  final ValueChanged<int> onTabSelected;
  final int calorieGoal;

  const HomeMetricsRow({
    super.key,
    required this.completedRoutines,
    required this.totalRoutines,
    required this.todayCalories,
    required this.todayExpenses,
    required this.onTabSelected,
    this.calorieGoal = 2300,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                  boxShadow: [
                    if (theme.glow.enabled)
                      BoxShadow(
                        color: colors.primary.withOpacity(theme.glow.intensity),
                        blurRadius: 6,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                loc.tr('todaySummary'),
                style: AppTypography.labelUppercase.copyWith(
                  fontSize: 12,
                  letterSpacing: 1.4,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            // 1. Calories Tile
            Expanded(
              child: _MetricTile(
                title: loc.tr('calories'),
                value: CurrencyFormatter.formatCalories(todayCalories),
                icon: LucideIcons.flame,
                accentColor: colors.caloriesAccent,
                sublabel: todayCalories > 0
                    ? (loc.isArabic ? 'مسجلة' : 'logged')
                    : (loc.isArabic ? 'هدف $calorieGoal' : 'Goal $calorieGoal'),
                onTap: () {
                  VibrationService.vibrateTick();
                  onTabSelected(0);
                },
              ),
            ),
            const SizedBox(width: 10),

            // 2. Expenses Tile
            Expanded(
              child: _MetricTile(
                title: loc.tr('expenses'),
                value: CurrencyFormatter.formatEGP(todayExpenses),
                icon: LucideIcons.wallet,
                accentColor: colors.expensesAccent,
                sublabel: todayExpenses > 0
                    ? (loc.isArabic ? 'مصروف اليوم' : "today's total")
                    : (loc.isArabic ? 'لا مصاريف' : 'no spend'),
                onTap: () {
                  VibrationService.vibrateTick();
                  onTabSelected(3);
                },
              ),
            ),
            const SizedBox(width: 10),

            // 3. Routines Tile
            Expanded(
              child: _MetricTile(
                title: loc.tr('routines'),
                value: totalRoutines > 0 ? '$completedRoutines / $totalRoutines' : '0 / 0',
                icon: LucideIcons.checkCircle2,
                accentColor: colors.routineAccent,
                sublabel: totalRoutines > 0
                    ? (completedRoutines == totalRoutines
                        ? (loc.isArabic ? 'مكتملة! 🎉' : 'Done! 🎉')
                        : '${((completedRoutines / totalRoutines) * 100).toInt()}%')
                    : (loc.isArabic ? 'عاداتك' : 'habits'),
                onTap: () {
                  VibrationService.vibrateTick();
                  onTabSelected(4);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricTile extends ConsumerWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final String sublabel;
  final VoidCallback onTap;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.surfaceSecondary.withOpacity(0.95),
              colors.surface.withOpacity(0.95),
            ],
          ),
          border: Border.all(
            color: accentColor.withOpacity(0.28),
            width: 1.2,
          ),
          boxShadow: [
            if (theme.glow.enabled)
              BoxShadow(
                color: accentColor.withOpacity(theme.glow.intensity * 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: accentColor.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, size: 14, color: accentColor),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.metadata.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              sublabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.metadata.copyWith(
                fontSize: 10,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
