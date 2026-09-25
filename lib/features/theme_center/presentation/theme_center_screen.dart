import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/theme/presets/app_presets.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/widgets/app_background.dart';
import 'widgets/background_customizer.dart';
import 'widgets/customize_section.dart';
import 'widgets/preset_selector_card.dart';
import 'widgets/theme_dna_section.dart';
import 'widgets/theme_live_preview.dart';

class ThemeCenterScreen extends ConsumerWidget {
  const ThemeCenterScreen({super.key});

  void _showResetDialog(BuildContext context, WidgetRef ref, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = ref.watch(effectiveThemeProvider).colors;
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colors.border.withOpacity(0.2)),
          ),
          title: Text(
            loc.tr('resetTheme'),
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            loc.tr('resetThemeConfirm'),
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                loc.tr('cancel'),
                style: TextStyle(color: colors.textMuted),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                VibrationService.vibratePress();
                await ref.read(themeProvider.notifier).resetToDefaults();
              },
              child: Text(
                loc.tr('resetTheme'),
                style: TextStyle(
                  color: colors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final themeState = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final loc = AppLocalizations.of(context);
    final colors = theme.colors;

    return AppBackground(
      slot: BackgroundSlot.settings,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              loc.isArabic ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
              color: colors.textPrimary,
            ),
            onPressed: () => context.pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.tr('themeCenter'),
                style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
              ),
              Text(
                loc.tr('themeCenterDesc'),
                style: AppTypography.metadata.copyWith(color: colors.textMuted),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            // Live Preview Card
            const ThemeLivePreview(),
            const SizedBox(height: 28),

            // SECTION 1: PRESETS
            Text(
              loc.tr('presets'),
              style: AppTypography.labelUppercase.copyWith(
                color: colors.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: kAppThemePresets.map((preset) {
                final isSelected = themeState.preset.id == preset.id;
                return PresetSelectorCard(
                  preset: preset,
                  isSelected: isSelected,
                  onSelect: () => notifier.setPreset(preset),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // SECTION 2: CUSTOMIZE
            Text(
              loc.tr('customize'),
              style: AppTypography.labelUppercase.copyWith(
                color: colors.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const CustomizeSection(),
            const SizedBox(height: 28),

            // SECTION 3: BACKGROUNDS
            Text(
              loc.tr('backgrounds'),
              style: AppTypography.labelUppercase.copyWith(
                color: colors.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const BackgroundCustomizer(),
            const SizedBox(height: 28),

            // SECTION 4: THEME DNA
            const ThemeDnaSection(),
            const SizedBox(height: 36),

            // SECTION 5: RESET THEME
            GestureDetector(
              onTap: () => _showResetDialog(context, ref, loc),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: colors.danger.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colors.danger.withOpacity(0.35),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.rotateCcw, size: 16, color: colors.danger),
                    const SizedBox(width: 8),
                    Text(
                      loc.tr('resetTheme'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
