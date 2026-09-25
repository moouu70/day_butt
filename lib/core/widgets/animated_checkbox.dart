import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/resolver/effective_theme_provider.dart';

class AnimatedCheckbox extends ConsumerWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color? activeColor;

  const AnimatedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final color = activeColor ?? theme.colors.primary;
    final inactiveBorder = theme.colors.border;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onChanged(!value);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(size * 0.32),
          border: Border.all(
            color: value ? color : inactiveBorder,
            width: 1.8,
          ),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: value
            ? Icon(
                Icons.check_rounded,
                size: size * 0.75,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
