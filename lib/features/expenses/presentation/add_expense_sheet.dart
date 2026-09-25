import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_sheet.dart';
import '../../../core/widgets/pill_toggle.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';

class AddExpenseSheet extends ConsumerStatefulWidget {
  final String initialType; // 'expense' or 'income'

  const AddExpenseSheet({
    super.key,
    this.initialType = 'expense',
  });

  static Future<void> show(BuildContext context, {String initialType = 'expense'}) {
    final loc = AppLocalizations.of(context);
    return GlassSheet.show(
      context: context,
      title: initialType == 'income' ? loc.tr('addIncome') : loc.tr('addExpense'),
      child: AddExpenseSheet(initialType: initialType),
    );
  }

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late int _typeIndex; // 0 = Expense, 1 = Income
  late String _selectedCategory;
  String? _errorText;

  static const List<Map<String, dynamic>> _expenseCategories = [
    {'key': 'Food', 'icon': LucideIcons.utensils},
    {'key': 'Transport', 'icon': LucideIcons.car},
    {'key': 'University', 'icon': LucideIcons.graduationCap},
    {'key': 'Shopping', 'icon': LucideIcons.shoppingBag},
    {'key': 'Bills', 'icon': LucideIcons.receipt},
    {'key': 'Other', 'icon': LucideIcons.moreHorizontal},
  ];

  static const List<Map<String, dynamic>> _incomeCategories = [
    {'key': 'Salary', 'icon': LucideIcons.briefcase},
    {'key': 'Allowance', 'icon': LucideIcons.wallet},
    {'key': 'Freelance', 'icon': LucideIcons.laptop},
    {'key': 'Gift', 'icon': LucideIcons.gift},
    {'key': 'Investment', 'icon': LucideIcons.trendingUp},
    {'key': 'Other', 'icon': LucideIcons.moreHorizontal},
  ];

  @override
  void initState() {
    super.initState();
    _typeIndex = widget.initialType == 'income' ? 1 : 0;
    _selectedCategory = _typeIndex == 0 ? 'Food' : 'Salary';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTypeChanged(int index) {
    setState(() {
      _typeIndex = index;
      _selectedCategory = index == 0 ? 'Food' : 'Salary';
      _errorText = null;
    });
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final text = _amountController.text.trim();
    final amount = double.tryParse(text);

    if (amount == null || amount <= 0) {
      setState(() => _errorText = loc.tr('enterValidAmount'));
      return;
    }

    final db = ref.read(databaseProvider);
    final note = _noteController.text.trim();
    final type = _typeIndex == 0 ? 'expense' : 'income';

    await db.into(db.expenseEntries).insert(
      ExpenseEntriesCompanion.insert(
        id: const Uuid().v4(),
        amount: amount,
        category: _selectedCategory,
        type: drift.Value(type),
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
    final isExpense = _typeIndex == 0;
    final categories = isExpense ? _expenseCategories : _incomeCategories;
    final savedExpensesAsync = ref.watch(savedExpensesStreamProvider);
    final activeColor = isExpense ? colors.expensesAccent : colors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Type Selector: [ Expense | Income ] (Localized)
        Center(
          child: PillToggle(
            options: [loc.tr('expense'), loc.tr('income')],
            selectedIndex: _typeIndex,
            onSelected: _onTypeChanged,
            height: 38,
          ),
        ),

        if (isExpense)
          savedExpensesAsync.maybeWhen(
            data: (savedList) {
              if (savedList.isEmpty) return const SizedBox(height: 16);
              return Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 4),
                child: SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: savedList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = savedList[index];
                      final isSelected = _noteController.text == item.name &&
                          _amountController.text == item.amount.toStringAsFixed(item.amount.truncateToDouble() == item.amount ? 0 : 2);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _amountController.text = item.amount.toStringAsFixed(
                              item.amount.truncateToDouble() == item.amount ? 0 : 2,
                            );
                            _noteController.text = item.name;
                            _selectedCategory = item.category;
                            _errorText = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.expensesAccent.withOpacity(0.25)
                                : colors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? colors.expensesAccent
                                  : colors.border.withOpacity(0.15),
                              width: isSelected ? 1.4 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : colors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${item.amount.toStringAsFixed(item.amount.truncateToDouble() == item.amount ? 0 : 2)} ${loc.isArabic ? "ج.م" : "EGP"}',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: colors.expensesAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            orElse: () => const SizedBox(height: 16),
          )
        else
          const SizedBox(height: 16),

        AppTextField(
          controller: _amountController,
          hintText: isExpense ? '120' : '1500',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          suffix: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsetsDirectional.only(end: 8),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              loc.isArabic ? 'ج.م' : 'EGP',
              style: AppTypography.metadata.copyWith(
                color: activeColor,
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

        const SizedBox(height: 14),

        Text(
          loc.tr('category'),
          style: AppTypography.metadata.copyWith(
            color: colors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final key = cat['key'] as String;
            final icon = cat['icon'] as IconData;
            final displayName = loc.categoryName(key);
            final isSelected = _selectedCategory == key;

            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                    ? activeColor.withOpacity(0.18)
                    : colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? activeColor : colors.border.withOpacity(0.15),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? activeColor : colors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : colors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 14),

        AppTextField(
          controller: _noteController,
          hintText: isExpense ? loc.tr('expenseNoteHint') : loc.tr('incomeNoteHint'),
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
                label: isExpense ? loc.tr('saveExpense') : loc.tr('saveIncome'),
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
