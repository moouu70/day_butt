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
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';

class AddSavedExpenseSheet extends ConsumerStatefulWidget {
  final SavedExpense? existing;

  const AddSavedExpenseSheet({
    super.key,
    this.existing,
  });

  static Future<void> show(BuildContext context, {SavedExpense? existing}) {
    final loc = AppLocalizations.of(context);
    return GlassSheet.show(
      context: context,
      title: existing != null ? loc.tr('editSavedExpense') : loc.tr('addSavedExpense'),
      child: AddSavedExpenseSheet(existing: existing),
    );
  }

  @override
  ConsumerState<AddSavedExpenseSheet> createState() => _AddSavedExpenseSheetState();
}

class _AddSavedExpenseSheetState extends ConsumerState<AddSavedExpenseSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late String _selectedCategory;
  String? _errorText;

  static const List<Map<String, dynamic>> _categories = [
    {'key': 'Food', 'icon': LucideIcons.utensils},
    {'key': 'Transport', 'icon': LucideIcons.car},
    {'key': 'University', 'icon': LucideIcons.graduationCap},
    {'key': 'Shopping', 'icon': LucideIcons.shoppingBag},
    {'key': 'Bills', 'icon': LucideIcons.receipt},
    {'key': 'Other', 'icon': LucideIcons.moreHorizontal},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _amountController = TextEditingController(
      text: widget.existing != null ? widget.existing!.amount.toStringAsFixed(widget.existing!.amount.truncateToDouble() == widget.existing!.amount ? 0 : 2) : '',
    );
    _selectedCategory = widget.existing?.category ?? 'Food';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = loc.tr('enterName'));
      return;
    }

    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() => _errorText = loc.tr('enterValidAmount'));
      return;
    }

    final db = ref.read(databaseProvider);

    if (widget.existing != null) {
      await (db.update(db.savedExpenses)..where((t) => t.id.equals(widget.existing!.id))).write(
        SavedExpensesCompanion(
          name: drift.Value(name),
          amount: drift.Value(amount),
          category: drift.Value(_selectedCategory),
        ),
      );
    } else {
      await db.into(db.savedExpenses).insert(
        SavedExpensesCompanion.insert(
          id: const Uuid().v4(),
          name: name,
          amount: amount,
          category: drift.Value(_selectedCategory),
          createdAt: DateTime.now(),
        ),
      );
    }

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
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _nameController,
          hintText: loc.isArabic ? 'مثال: قهوة، باص، وجبة' : 'e.g. Coffee, Metro, Lunch',
          labelText: loc.tr('savedExpenseName'),
          autofocus: true,
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _amountController,
          hintText: '30',
          labelText: loc.tr('savedExpenseAmount'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                color: colors.expensesAccent,
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
          children: _categories.map((cat) {
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
                      ? colors.expensesAccent.withOpacity(0.18)
                      : colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? colors.expensesAccent : colors.border.withOpacity(0.15),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? colors.expensesAccent : colors.textMuted,
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
