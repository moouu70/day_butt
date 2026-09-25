import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/theme/models/theme_colors.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/pill_toggle.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import 'add_expense_sheet.dart';
import 'add_saved_expense_sheet.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  int _filterIndex = 0; // 0 = All, 1 = Expenses, 2 = Income

  Future<void> _seedDefaultSavedExpenses() async {
    final db = ref.read(databaseProvider);
    final loc = AppLocalizations.of(context);
    final isAr = loc.isArabic;
    final defaults = [
      {'name': isAr ? 'قهوة' : 'Coffee', 'amount': 30.0, 'cat': 'Food'},
      {
        'name': isAr ? 'مواصلات' : 'Transport',
        'amount': 15.0,
        'cat': 'Transport',
      },
      {'name': isAr ? 'غداء' : 'Lunch', 'amount': 75.0, 'cat': 'Food'},
      {'name': isAr ? 'سناك' : 'Snack', 'amount': 25.0, 'cat': 'Food'},
    ];
    for (final d in defaults) {
      await db
          .into(db.savedExpenses)
          .insert(
            SavedExpensesCompanion.insert(
              id: const Uuid().v4(),
              name: d['name'] as String,
              amount: d['amount'] as double,
              category: drift.Value(d['cat'] as String),
              createdAt: DateTime.now(),
            ),
          );
    }
  }

  Future<void> _logSavedExpense(SavedExpense label) async {
    final db = ref.read(databaseProvider);
    final entryId = const Uuid().v4();
    await db
        .into(db.expenseEntries)
        .insert(
          ExpenseEntriesCompanion.insert(
            id: entryId,
            amount: label.amount,
            category: label.category,
            type: const drift.Value('expense'),
            note: drift.Value(label.name),
            createdAt: DateTime.now(),
          ),
        );
    VibrationService.vibrateTick();
    if (mounted) {
      final loc = AppLocalizations.of(context);
      final colors = ref.read(effectiveThemeProvider).colors;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(LucideIcons.check, color: colors.success, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  loc.tr('savedExpenseLogged', {
                    'name': label.name,
                    'amount': CurrencyFormatter.formatEGP(
                      label.amount,
                      isArabic: loc.isArabic,
                    ),
                  }),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: loc.tr('delete'),
            textColor: colors.danger,
            onPressed: () async {
              await (db.delete(
                db.expenseEntries,
              )..where((t) => t.id.equals(entryId))).go();
            },
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSavedExpenseOptions(SavedExpense label) {
    VibrationService.vibratePress();
    final loc = AppLocalizations.of(context);
    final theme = ref.read(effectiveThemeProvider);
    final colors = theme.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: colors.border.withOpacity(0.2)),
            left: BorderSide(color: colors.border.withOpacity(0.2)),
            right: BorderSide(color: colors.border.withOpacity(0.2)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.textMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${label.name} (${CurrencyFormatter.formatEGP(label.amount, isArabic: loc.isArabic)})',
              style: AppTypography.sectionTitle.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(LucideIcons.pencil, color: colors.primary),
              title: Text(
                loc.tr('editSavedExpense'),
                style: TextStyle(color: colors.textPrimary),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                AddSavedExpenseSheet.show(context, existing: label);
              },
            ),
            ListTile(
              leading: Icon(LucideIcons.trash2, color: colors.danger),
              title: Text(
                loc.tr('deleteSavedExpense'),
                style: TextStyle(color: colors.danger),
              ),
              onTap: () async {
                Navigator.of(ctx).pop();
                final db = ref.read(databaseProvider);
                await (db.delete(
                  db.savedExpenses,
                )..where((t) => t.id.equals(label.id))).go();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String cat, String type, [ThemeColors? colors]) {
    final effectiveColors = colors ?? ref.read(effectiveThemeProvider).colors;

    if (type == 'income') {
      switch (cat.toLowerCase()) {
        case 'salary':
          return effectiveColors.success;
        case 'allowance':
          return effectiveColors.secondary;
        case 'freelance':
          return effectiveColors.primary;
        case 'gift':
          return effectiveColors.expensesAccent;
        case 'investment':
          return effectiveColors.success;
        default:
          return effectiveColors.success;
      }
    }

    switch (cat.toLowerCase()) {
      case 'food':
        return effectiveColors.expensesAccent;
      case 'transportation':
      case 'transport':
        return effectiveColors.secondary;
      case 'university':
        return effectiveColors.universityAccent;
      case 'shopping':
        return effectiveColors.primary;
      case 'bills':
        return effectiveColors.warning;
      default:
        return effectiveColors.expensesAccent;
    }
  }

  IconData _getCategoryIcon(String cat, String type) {
    if (type == 'income') {
      switch (cat.toLowerCase()) {
        case 'salary':
          return LucideIcons.briefcase;
        case 'allowance':
          return LucideIcons.wallet;
        case 'freelance':
          return LucideIcons.laptop;
        case 'gift':
          return LucideIcons.gift;
        case 'investment':
          return LucideIcons.trendingUp;
        default:
          return LucideIcons.moreHorizontal;
      }
    }

    switch (cat.toLowerCase()) {
      case 'food':
        return LucideIcons.utensils;
      case 'transportation':
      case 'transport':
        return LucideIcons.car;
      case 'university':
        return LucideIcons.graduationCap;
      case 'shopping':
        return LucideIcons.shoppingBag;
      case 'bills':
        return LucideIcons.receipt;
      default:
        return LucideIcons.tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final todayEntriesAsync = ref.watch(todayExpenseEntriesStreamProvider);
    final todayExpenses = ref.watch(todayExpensesSumStreamProvider);
    final todayIncome = ref.watch(todayIncomeSumStreamProvider);
    final todayNet = ref.watch(todayNetSumStreamProvider);
    final expenseCategories = ref.watch(todayExpenseCategoryBreakdownProvider);
    final incomeCategories = ref.watch(todayIncomeCategoryBreakdownProvider);
    final savedExpensesAsync = ref.watch(savedExpensesStreamProvider);

    return AppBackground(
      slot: BackgroundSlot.expenses,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            loc.tr('expensesAndIncome'),
            style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
          ),
          actions: [
            IconButton(
              icon: Icon(
                LucideIcons.history,
                size: 20,
                color: colors.textPrimary,
              ),
              tooltip: loc.tr('history'),
              onPressed: () => context.push(AppRoutes.expensesHistory),
            ),
          ],
        ),
        body: Column(
          children: [
            // Top Overview Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(18),
                borderRadius: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.tr('todaysNetBalance'),
                          style: AppTypography.labelUppercase.copyWith(
                            letterSpacing: 1.5,
                            color: colors.expensesAccent,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.expensesAccent.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.wallet,
                            size: 16,
                            color: colors.expensesAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      todayNet >= 0
                          ? '+${CurrencyFormatter.formatEGP(todayNet)}'
                          : '-${CurrencyFormatter.formatEGP(-todayNet)}',
                      style: AppTypography.dashboardNumber.copyWith(
                        fontSize: 32,
                        color: todayNet >= 0 ? colors.success : colors.danger,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Income & Expense Sub-Cards
                    Row(
                      children: [
                        // Income Tile
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colors.success.withOpacity(0.25),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: colors.success.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LucideIcons.arrowDownLeft,
                                    size: 14,
                                    color: colors.success,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.tr('income'),
                                        style: AppTypography.metadata.copyWith(
                                          color: colors.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '+${CurrencyFormatter.formatEGP(todayIncome)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.cardTitle.copyWith(
                                          fontSize: 13,
                                          color: colors.success,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Expense Tile
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colors.expensesAccent.withOpacity(0.25),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: colors.expensesAccent.withOpacity(
                                      0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LucideIcons.arrowUpRight,
                                    size: 14,
                                    color: colors.expensesAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.tr('expenses'),
                                        style: AppTypography.metadata.copyWith(
                                          color: colors.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '-${CurrencyFormatter.formatEGP(todayExpenses)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.cardTitle.copyWith(
                                          fontSize: 13,
                                          color: colors.expensesAccent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Category Breakdown Chips
                    if (expenseCategories.isNotEmpty ||
                        incomeCategories.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ...expenseCategories.entries.map((item) {
                            final color = _getCategoryColor(
                              item.key,
                              'expense',
                              colors,
                            );
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: color.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${loc.categoryName(item.key)}: -${CurrencyFormatter.formatEGP(item.value, isArabic: loc.isArabic)}',
                                    style: AppTypography.metadata.copyWith(
                                      fontSize: 10,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          ...incomeCategories.entries.map((item) {
                            final color = _getCategoryColor(
                              item.key,
                              'income',
                              colors,
                            );
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: color.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${loc.categoryName(item.key)}: +${CurrencyFormatter.formatEGP(item.value, isArabic: loc.isArabic)}',
                                    style: AppTypography.metadata.copyWith(
                                      fontSize: 10,
                                      color: colors.success,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Quick Add Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => AddExpenseSheet.show(
                              context,
                              initialType: 'income',
                            ),
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: colors.success.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.success.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.plus,
                                    size: 15,
                                    color: colors.success,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    loc.tr('addIncome'),
                                    style: TextStyle(
                                      color: colors.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => AddExpenseSheet.show(
                              context,
                              initialType: 'expense',
                            ),
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: colors.expensesAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors.expensesAccent.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.minus,
                                    size: 15,
                                    color: colors.expensesAccent,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    loc.tr('addExpense'),
                                    style: TextStyle(
                                      color: colors.expensesAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Saved Expenses (Presets) Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.bookmarkCheck,
                            size: 14,
                            color: colors.expensesAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            loc.tr('savedExpenses'),
                            style: AppTypography.labelUppercase.copyWith(
                              letterSpacing: 1.2,
                              color: colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => AddSavedExpenseSheet.show(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.plus,
                                size: 12,
                                color: colors.expensesAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                loc.tr('add'),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.expensesAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  savedExpensesAsync.when(
                    loading: () => const SizedBox(height: 38),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (savedLabels) {
                      if (savedLabels.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceSecondary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colors.border.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.info,
                                size: 14,
                                color: colors.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  loc.tr('savedExpenseDesc'),
                                  style: AppTypography.metadata.copyWith(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _seedDefaultSavedExpenses,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: Text(
                                  loc.isArabic ? 'إضافة أمثلة' : 'Add Samples',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.expensesAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: savedLabels.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            if (index == savedLabels.length) {
                              return GestureDetector(
                                onTap: () => AddSavedExpenseSheet.show(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceSecondary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colors.border.withOpacity(0.15),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.plus,
                                        size: 14,
                                        color: colors.expensesAccent,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        loc.tr('add'),
                                        style: TextStyle(
                                          color: colors.expensesAccent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final label = savedLabels[index];
                            final catColor = _getCategoryColor(
                              label.category,
                              'expense',
                              colors,
                            );
                            final catIcon = _getCategoryIcon(
                              label.category,
                              'expense',
                            );

                            return GestureDetector(
                              onTap: () => _logSavedExpense(label),
                              onLongPress: () =>
                                  _showSavedExpenseOptions(label),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: catColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: catColor.withOpacity(0.35),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(catIcon, size: 13, color: catColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      label.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.background.withOpacity(
                                          0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        CurrencyFormatter.formatEGP(
                                          label.amount,
                                          isArabic: loc.isArabic,
                                        ),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: catColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Filter Tabs & List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PillToggle(
                    options: [
                      loc.tr('all'),
                      loc.tr('expenses'),
                      loc.tr('income'),
                    ],
                    selectedIndex: _filterIndex,
                    onSelected: (idx) => setState(() => _filterIndex = idx),
                    height: 32,
                  ),
                  todayEntriesAsync.maybeWhen(
                    data: (entries) {
                      final filtered = entries.where((e) {
                        if (_filterIndex == 1) return e.type != 'income';
                        if (_filterIndex == 2) return e.type == 'income';
                        return true;
                      }).toList();
                      return Text(
                        '${filtered.length} ${filtered.length == 1 ? loc.tr('entry') : loc.tr('entries')}',
                        style: AppTypography.metadata.copyWith(
                          color: colors.textMuted,
                        ),
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Transactions List
            Expanded(
              child: todayEntriesAsync.when(
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: colors.expensesAccent,
                  ),
                ),
                error: (err, _) => Center(
                  child: Text('Error: $err', style: AppTypography.bodyMuted),
                ),
                data: (entries) {
                  final filtered = entries.where((e) {
                    if (_filterIndex == 1) return e.type != 'income';
                    if (_filterIndex == 2) return e.type == 'income';
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: LucideIcons.receipt,
                      title: _filterIndex == 1
                          ? loc.tr('noExpensesToday')
                          : _filterIndex == 2
                          ? loc.tr('noIncomeToday')
                          : loc.tr('noTransactionsToday'),
                      buttonLabel: _filterIndex == 2
                          ? '+ ${loc.tr('addIncome')}'
                          : '+ ${loc.tr('addExpense')}',
                      onButtonPressed: () => AddExpenseSheet.show(
                        context,
                        initialType: _filterIndex == 2 ? 'income' : 'expense',
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      final isIncome = entry.type == 'income';
                      final catColor = _getCategoryColor(
                        entry.category,
                        entry.type,
                        colors,
                      );
                      final catIcon = _getCategoryIcon(
                        entry.category,
                        entry.type,
                      );

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
                          (db.delete(
                            db.expenseEntries,
                          )..where((t) => t.id.equals(entry.id))).go();
                        },
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          borderRadius: 16,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: catColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: catColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Icon(catIcon, size: 18, color: catColor),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          entry.note != null &&
                                                  entry.note!.isNotEmpty
                                              ? entry.note!
                                              : loc.categoryName(
                                                  entry.category,
                                                ),
                                          style: AppTypography.cardTitle
                                              .copyWith(
                                                color: colors.textPrimary,
                                              ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isIncome
                                                ? colors.success.withOpacity(
                                                    0.15,
                                                  )
                                                : colors.surfaceSecondary,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            isIncome
                                                ? loc.tr('income').toUpperCase()
                                                : loc
                                                      .tr('expense')
                                                      .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: isIncome
                                                  ? colors.success
                                                  : colors.textMuted,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${loc.categoryName(entry.category)} • ${AppDateUtils.formatTime12Hour(entry.createdAt, context: context)}',
                                      style: AppTypography.metadata.copyWith(
                                        color: colors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                isIncome
                                    ? '+${CurrencyFormatter.formatEGP(entry.amount, isArabic: loc.isArabic)}'
                                    : '-${CurrencyFormatter.formatEGP(entry.amount, isArabic: loc.isArabic)}',
                                style: AppTypography.cardTitle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isIncome
                                      ? colors.success
                                      : colors.textPrimary,
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
