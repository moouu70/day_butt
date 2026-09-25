import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_typography.dart';
import '../theme/providers/theme_provider.dart';

class GlassButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isDanger;
  final double height;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isDanger = false,
    this.height = 50,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final glow = theme.glow;

    Color bg;
    Color border;
    Color text;

    if (isDanger) {
      bg = colors.danger.withOpacity(0.18);
      border = colors.danger.withOpacity(0.4);
      text = colors.danger;
    } else if (isPrimary) {
      bg = colors.primary;
      border = colors.secondary.withOpacity(0.5);
      text = Colors.white;
    } else {
      bg = colors.surface.withOpacity(0.6);
      border = colors.border;
      text = colors.textPrimary;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
        boxShadow: isPrimary && glow.enabled && glow.intensity > 0
            ? [
                BoxShadow(
                  color: colors.primary.withOpacity((glow.intensity * 0.75).clamp(0.1, 0.6)),
                  blurRadius: glow.radius,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: text),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cardTitle.copyWith(
                            color: text,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
