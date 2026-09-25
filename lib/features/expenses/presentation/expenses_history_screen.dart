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

class ExpensesHistoryScreen extends ConsumerWidget {
  const ExpensesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final allEntriesAsync = ref.watch(allExpenseEntriesStreamProvider);

    return AppBackground(
      slot: BackgroundSlot.expenses,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            loc.tr('financialHistory'),
            style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
          ),
        ),
        body: allEntriesAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: colors.expensesAccent)),
          error: (err, _) => Center(child: Text('Error: $err', style: AppTypography.bodyMuted)),
          data: (entries) {
            if (entries.isEmpty) {
              return EmptyState(
                icon: LucideIcons.wallet,
                title: loc.tr('noTransactionsToday'),
                subtitle: loc.tr('allClassesCompletedDesc'),
              );
            }

            // Group by date key
            final Map<String, List<ExpenseEntry>> grouped = {};
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
                final date = dayEntries.first.createdAt;
                final isToday = AppDateUtils.isToday(date);

                final dayIncome = dayEntries
                    .where((e) => e.type == 'income')
                    .fold<double>(0.0, (sum, item) => sum + item.amount);
                final dayExpenses = dayEntries
                    .where((e) => e.type != 'income')
                    .fold<double>(0.0, (sum, item) => sum + item.amount);
                final dayNet = dayIncome - dayExpenses;

                return GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 18,
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
                                  color: isToday ? colors.expensesAccent : colors.textPrimary,
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.expensesAccent.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loc.tr('today').toUpperCase(),
                                    style: AppTypography.badge.copyWith(fontSize: 9, color: colors.expensesAccent),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            dayNet >= 0
                                ? '+${CurrencyFormatter.formatEGP(dayNet)}'
                                : '-${CurrencyFormatter.formatEGP(-dayNet)}',
                            style: AppTypography.cardTitle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: dayNet >= 0 ? colors.success : colors.danger,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Income & Expense totals for the day
                      Row(
                        children: [
                          if (dayIncome > 0) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.arrowDownLeft, size: 12, color: colors.success),
                                const SizedBox(width: 3),
                                Text(
                                  '+${CurrencyFormatter.formatEGP(dayIncome, isArabic: loc.isArabic)}',
                                  style: AppTypography.metadata.copyWith(
                                    color: colors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                          ],
                          if (dayExpenses > 0) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.arrowUpRight, size: 12, color: colors.expensesAccent),
                                const SizedBox(width: 3),
                                Text(
                                  '-${CurrencyFormatter.formatEGP(dayExpenses, isArabic: loc.isArabic)}',
                                  style: AppTypography.metadata.copyWith(
                                    color: colors.expensesAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),

                      // List of entries for this day
                      ...dayEntries.map((e) {
                        final isIncome = e.type == 'income';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isIncome ? colors.success : colors.expensesAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    e.note != null && e.note!.isNotEmpty
                                        ? '${loc.categoryName(e.category)} (${e.note}) • ${AppDateUtils.formatTime12Hour(e.createdAt, context: context)}'
                                        : '${loc.categoryName(e.category)} • ${AppDateUtils.formatTime12Hour(e.createdAt, context: context)}',
                                    style: AppTypography.metadata.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                isIncome
                                    ? '+${CurrencyFormatter.formatEGP(e.amount, isArabic: loc.isArabic)}'
                                    : '-${CurrencyFormatter.formatEGP(e.amount, isArabic: loc.isArabic)}',
                                style: AppTypography.metadata.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isIncome ? colors.success : colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
