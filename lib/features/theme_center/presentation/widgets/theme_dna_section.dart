import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/models/effective_theme.dart';
import '../../../../core/theme/providers/theme_provider.dart';
import '../../../../core/theme/services/theme_dna_formatter.dart';

class ThemeDnaSection extends ConsumerWidget {
  const ThemeDnaSection({super.key});

  void _copyDna(BuildContext context, EffectiveTheme theme, AppLocalizations loc) {
    VibrationService.vibratePress();
    final dna = ThemeDnaFormatter.format(theme);
    Clipboard.setData(ClipboardData(text: dna));

    final colors = theme.colors;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(LucideIcons.checkCheck, color: colors.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                loc.tr('themeDnaCopied'),
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.border.withOpacity(0.3)),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDnaPreview(BuildContext context, EffectiveTheme theme, AppLocalizations loc) {
    VibrationService.vibratePress();
    final dna = ThemeDnaFormatter.format(theme);
    final colors = theme.colors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: colors.border.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sheet Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        LucideIcons.sparkles,
                        color: colors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.tr('themeDnaModalTitle'),
                            style: AppTypography.cardTitle.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            loc.tr('themeDnaModalDesc'),
                            style: AppTypography.metadata.copyWith(
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.x, color: colors.textSecondary, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: colors.border.withOpacity(0.2)),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.backgroundDeep,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border.withOpacity(0.15)),
                    ),
                    child: SelectableText(
                      dna,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.5,
                        color: colors.textPrimary.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  border: Border(
                    top: BorderSide(color: colors.border.withOpacity(0.15)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _copyDna(context, theme, loc);
                        },
                        icon: const Icon(LucideIcons.copy, size: 16),
                        label: Text(
                          loc.tr('copyDna'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final loc = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          loc.tr('themeDna'),
          style: AppTypography.labelUppercase.copyWith(
            color: colors.primary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // DNA Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.border.withOpacity(0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      LucideIcons.sparkles,
                      size: 20,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.tr('themeDna'),
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loc.tr('themeDnaDesc'),
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons: [ View DNA ] and [ Copy DNA ]
              Row(
                children: [
                  // View DNA Button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: colors.border.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _showDnaPreview(context, theme, loc),
                      icon: Icon(
                        LucideIcons.eye,
                        size: 15,
                        color: colors.textSecondary,
                      ),
                      label: Text(
                        loc.tr('viewDna'),
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Copy DNA Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _copyDna(context, theme, loc),
                      icon: const Icon(LucideIcons.copy, size: 15),
                      label: Text(
                        loc.tr('copyDna'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
