import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/resolver/effective_theme_provider.dart';

class GlassBottomBarItem {
  final IconData icon;
  final String label;

  const GlassBottomBarItem({
    required this.icon,
    required this.label,
  });
}

class GlassBottomBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<GlassBottomBarItem> items = [
    GlassBottomBarItem(icon: LucideIcons.flame, label: 'Calories'),
    GlassBottomBarItem(icon: LucideIcons.graduationCap, label: 'University'),
    GlassBottomBarItem(icon: LucideIcons.home, label: 'Home'),
    GlassBottomBarItem(icon: LucideIcons.creditCard, label: 'Expenses'),
    GlassBottomBarItem(icon: LucideIcons.checkSquare, label: 'Routine'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.88),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(theme.glass.shadowOpacity),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final isSelected = currentIndex == index;
                  final item = items[index];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withOpacity(0.24)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: colors.primary.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: isSelected
                                  ? Colors.white
                                  : colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.white : colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
