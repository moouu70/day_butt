import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/calorie_goal_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../database/database_provider.dart';
import 'add_calories_sheet.dart';
import 'widgets/edit_calorie_goal_sheet.dart';

class CaloriesScreen extends ConsumerWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final todayEntriesAsync = ref.watch(todayCalorieEntriesStreamProvider);
    final todayTotal = ref.watch(todayCaloriesSumStreamProvider);
    final dailyGoal = ref.watch(calorieGoalProvider);
    final progress = dailyGoal > 0 ? (todayTotal / dailyGoal).clamp(0.0, 1.0) : 0.0;

    return AppBackground(
      slot: BackgroundSlot.calories,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            loc.tr('calories'),
            style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
          ),
          actions: [
            IconButton(
              icon: Icon(LucideIcons.target, size: 20, color: colors.textPrimary),
              tooltip: loc.tr('editDailyGoal'),
              onPressed: () => EditCalorieGoalSheet.show(context),
            ),
            IconButton(
              icon: Icon(LucideIcons.history, size: 20, color: colors.textPrimary),
              tooltip: loc.tr('history'),
              onPressed: () => context.push(AppRoutes.caloriesHistory),
            ),
          ],
        ),
        body: Column(
          children: [
            // Top Dashboard Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.tr('todaySummary'),
                          style: AppTypography.labelUppercase.copyWith(
                            letterSpacing: 1.5,
                            color: colors.caloriesAccent,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.caloriesAccent.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(LucideIcons.flame, size: 18, color: colors.caloriesAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.formatCalories(todayTotal),
                      style: AppTypography.dashboardNumber.copyWith(
                        fontSize: 34,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => EditCalorieGoalSheet.show(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${loc.tr('dailyGoal')}: ${CurrencyFormatter.formatCalories(dailyGoal)}',
                                  style: AppTypography.metadata.copyWith(color: colors.textSecondary),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceSecondary,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: colors.border.withOpacity(0.15)),
                                  ),
                                  child: Icon(
                                    LucideIcons.pencil,
                                    size: 11,
                                    color: colors.caloriesAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: AppTypography.metadata.copyWith(
                            color: colors.caloriesAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: colors.surfaceSecondary,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.caloriesAccent),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlassButton(
                      label: loc.tr('addCalories'),
                      onPressed: () => AddCaloriesSheet.show(context),
                      height: 44,
                    ),
                  ],
                ),
              ),
            ),

            // Daily Entries List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.tr('todaysLog'),
                    style: AppTypography.sectionTitle.copyWith(color: colors.textPrimary),
                  ),
                  todayEntriesAsync.maybeWhen(
                    data: (entries) => Text(
                      '${entries.length} ${entries.length == 1 ? loc.tr('entry') : loc.tr('entries')}',
                      style: AppTypography.metadata.copyWith(color: colors.textMuted),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: todayEntriesAsync.when(
                loading: () => Center(child: CircularProgressIndicator(color: colors.caloriesAccent)),
                error: (err, _) => Center(child: Text('Error: $err', style: AppTypography.bodyMuted)),
                data: (entries) {
                  if (entries.isEmpty) {
                    return EmptyState(
                      icon: LucideIcons.utensils,
                      title: loc.tr('noCaloriesLogged'),
                      buttonLabel: loc.tr('addCalories'),
                      onButtonPressed: () => AddCaloriesSheet.show(context),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Dismissible(
                        key: Key(entry.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: colors.danger.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(LucideIcons.trash2, color: colors.danger),
                        ),
                        onDismissed: (_) {
                          final db = ref.read(databaseProvider);
                          (db.delete(db.calorieEntries)..where((t) => t.id.equals(entry.id))).go();
                        },
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          borderRadius: 16,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors.surfaceSecondary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: colors.border.withOpacity(0.15)),
                                ),
                                child: Icon(LucideIcons.flame, size: 18, color: colors.caloriesAccent),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.note != null && entry.note!.isNotEmpty
                                          ? entry.note!
                                          : loc.tr('calorieEntry'),
                                      style: AppTypography.cardTitle.copyWith(color: colors.textPrimary),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      AppDateUtils.formatTime12Hour(entry.createdAt, context: context),
                                      style: AppTypography.metadata.copyWith(color: colors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyFormatter.formatCalories(entry.calories),
                                style: AppTypography.cardTitle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
