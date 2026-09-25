import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/resolver/effective_theme_provider.dart';
import '../theme/app_typography.dart';
import 'glass_button.dart';

class EmptyState extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                icon,
                size: 32,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.cardTitle.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.metadata.copyWith(color: colors.textMuted),
              ),
            ],
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 160, maxWidth: 240),
                child: GlassButton(
                  label: buttonLabel!,
                  onPressed: onButtonPressed,
                  height: 42,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
