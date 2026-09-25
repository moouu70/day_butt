import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/providers/theme_provider.dart';

class ThemeLivePreview extends ConsumerWidget {
  const ThemeLivePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final themeState = ref.watch(themeProvider);
    final loc = AppLocalizations.of(context);
    final isArabic = loc.isArabic;
    final colors = theme.colors;
    final glass = theme.glass;
    final glow = theme.glow;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.border.withOpacity(glass.borderOpacity.clamp(0.08, 0.4)),
          width: 1.2,
        ),
        boxShadow: [
          if (glow.enabled)
            BoxShadow(
              color: colors.primary.withOpacity(glow.intensity * 0.25),
              blurRadius: glow.radius * 1.5,
              offset: const Offset(0, 4),
            ),
          BoxShadow(
            color: Colors.black.withOpacity(glass.shadowOpacity),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Live Tag and Preset Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary,
                      boxShadow: [
                        if (glow.enabled)
                          BoxShadow(
                            color: colors.primary.withOpacity(glow.intensity),
                            blurRadius: 8,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.tr('livePreview'),
                    style: AppTypography.labelUppercase.copyWith(
                      color: colors.primary,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Text(
                  themeState.preset.getName(isArabic),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Miniature App Card Simulation
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceSecondary.withOpacity(glass.opacity + 0.15),
              borderRadius: BorderRadius.circular(glass.cornerRadius * 0.7),
              border: Border.all(
                color: colors.border.withOpacity(glass.borderOpacity),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.sparkles,
                            size: 14,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? 'اليوم' : 'Today',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '85%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Miniature Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 6,
                    color: colors.surface,
                    child: FractionallySizedBox(
                      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      widthFactor: 0.85,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: colors.accentGradient,
                          boxShadow: [
                            if (glow.enabled)
                              BoxShadow(
                                color: colors.primary.withOpacity(glow.intensity * 0.6),
                                blurRadius: glow.radius,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Miniature Metrics & Hub Demo
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.border.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'السعرات' : 'Calories',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '1,840 kcal',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.surface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.border.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'المصاريف' : 'Expenses',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$45.00',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Mini Radial Hub
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary,
                        boxShadow: [
                          if (glow.enabled)
                            BoxShadow(
                              color: colors.primary.withOpacity(glow.intensity * 0.7),
                              blurRadius: glow.radius * 1.2,
                            ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.layoutGrid,
                          size: 16,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
