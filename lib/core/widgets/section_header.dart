import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/vibration_service.dart';
import '../theme/resolver/effective_theme_provider.dart';
import '../theme/app_typography.dart';

class SectionHeader extends ConsumerWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? trailing;
  final Color? accentColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.trailing,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final primary = accentColor ?? colors.primary;
    final secondary = accentColor ?? colors.secondary;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.sectionTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionLabel != null && onActionTap != null)
            GestureDetector(
              onTap: () {
                VibrationService.vibrateTick();
                onActionTap!();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primary.withOpacity(0.28),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (actionLabel!.contains('+')) ...[
                      Icon(LucideIcons.plus, size: 12, color: secondary),
                      const SizedBox(width: 4),
                      Text(
                        actionLabel!.replaceAll('+', '').trim(),
                        style: TextStyle(
                          color: secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ] else
                      Text(
                        actionLabel!,
                        style: TextStyle(
                          color: secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
