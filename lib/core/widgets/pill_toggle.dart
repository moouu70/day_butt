import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_typography.dart';
import '../theme/providers/theme_provider.dart';

class PillToggle extends ConsumerWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double height;

  const PillToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.height = 38,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return Container(
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(theme.glass.opacity.clamp(0.4, 0.95)),
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: colors.border.withOpacity(theme.glass.borderOpacity.clamp(0.1, 0.4))),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular((height - 6) / 2),
                boxShadow: isSelected && theme.glow.enabled
                    ? [
                        BoxShadow(
                          color: colors.primary.withOpacity((theme.glow.intensity * 0.5).clamp(0.1, 0.6)),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                options[index],
                style: AppTypography.badge.copyWith(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textSecondary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
