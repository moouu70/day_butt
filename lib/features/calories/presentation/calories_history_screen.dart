import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';

class CaloriesHistoryScreen extends ConsumerWidget {
  const CaloriesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final allEntriesAsync = ref.watch(allCalorieEntriesStreamProvider);

    return AppBackground(
      slot: BackgroundSlot.calories,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            loc.tr('calorieHistory'),
            style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
          ),
        ),
        body: allEntriesAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: colors.caloriesAccent)),
          error: (err, _) => Center(child: Text('Error: $err', style: AppTypography.bodyMuted)),
          data: (entries) {
            if (entries.isEmpty) {
              return EmptyState(
                icon: LucideIcons.calendar,
                title: loc.tr('noCalorieHistory'),
                subtitle: loc.tr('calorieHistoryDesc'),
              );
            }

            // Group entries by date
            final Map<String, List<CalorieEntry>> grouped = {};
            for (final e in entries) {
              final key = AppDateUtils.toDateKey(e.createdAt);
              grouped.putIfAbsent(key, () => []).add(e);
            }

            final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: sortedDates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final dateKey = sortedDates[index];
                final dayEntries = grouped[dateKey]!;
                final dayTotal = dayEntries.fold<int>(0, (sum, item) => sum + item.calories);
                final date = dayEntries.first.createdAt;
                final isToday = AppDateUtils.isToday(date);

                return GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                isToday ? loc.tr('today') : AppDateUtils.formatDate(date, context: context),
                                style: AppTypography.cardTitle.copyWith(
                                  color: isToday ? colors.caloriesAccent : colors.textPrimary,
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.caloriesAccent.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loc.tr('today').toUpperCase(),
                                    style: AppTypography.badge.copyWith(
                                      fontSize: 9,
                                      color: colors.caloriesAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            CurrencyFormatter.formatCalories(dayTotal),
                            style: AppTypography.cardTitle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Mini progress indicator relative to a 2500 kcal standard bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: (dayTotal / 2500).clamp(0.0, 1.0),
                          backgroundColor: colors.surfaceSecondary,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.caloriesAccent),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${dayEntries.length} ${dayEntries.length == 1 ? loc.tr('entry') : loc.tr('entries')}',
                        style: AppTypography.metadata.copyWith(color: colors.textMuted),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
