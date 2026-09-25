import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/resolver/effective_theme_provider.dart';
import '../theme/app_typography.dart';

class GlassChip extends ConsumerWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? activeColor;
  final EdgeInsetsGeometry padding;

  const GlassChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.activeColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final effectiveActiveColor = activeColor ?? colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveActiveColor.withOpacity(0.2)
              : colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? effectiveActiveColor.withOpacity(0.8)
                : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? effectiveActiveColor : colors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.badge.copyWith(
                color: isSelected ? colors.textPrimary : colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
