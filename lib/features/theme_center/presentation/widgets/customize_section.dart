import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/models/background_mode.dart';
import '../../../../core/theme/providers/theme_provider.dart';

class CustomizeSection extends ConsumerWidget {
  const CustomizeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final themeState = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final loc = AppLocalizations.of(context);
    final colors = theme.colors;

    final currentGlassIntensity = themeState.overrides.glassIntensity ??
        VisualIntensity.medium;
    final currentBlurIntensity = themeState.overrides.blurIntensity ??
        VisualIntensity.medium;
    final currentGlowIntensity = themeState.overrides.glowIntensity ??
        (themeState.preset.glow.enabled
            ? VisualIntensity.medium
            : VisualIntensity.off);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Glass Intensity
        Text(
          loc.tr('glassIntensity'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildIntensitySegment(
          values: [VisualIntensity.low, VisualIntensity.medium, VisualIntensity.high],
          labels: [loc.tr('low'), loc.tr('medium'), loc.tr('high')],
          selected: currentGlassIntensity,
          colors: colors,
          onSelected: (val) {
            VibrationService.vibrateTab();
            notifier.setGlassIntensity(val);
          },
        ),
        const SizedBox(height: 20),

        // Blur Intensity
        Text(
          loc.tr('blurIntensity'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildIntensitySegment(
          values: [VisualIntensity.low, VisualIntensity.medium, VisualIntensity.high],
          labels: [loc.tr('low'), loc.tr('medium'), loc.tr('high')],
          selected: currentBlurIntensity,
          colors: colors,
          onSelected: (val) {
            VibrationService.vibrateTab();
            notifier.setBlurIntensity(val);
          },
        ),
        const SizedBox(height: 20),

        // Glow Intensity
        Text(
          loc.tr('glow'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildIntensitySegment(
          values: [VisualIntensity.off, VisualIntensity.low, VisualIntensity.medium, VisualIntensity.high],
          labels: [loc.tr('off'), loc.tr('low'), loc.tr('medium'), loc.tr('high')],
          selected: currentGlowIntensity,
          colors: colors,
          onSelected: (val) {
            VibrationService.vibrateTab();
            notifier.setGlowIntensity(val);
          },
        ),
      ],
    );
  }

  Widget _buildIntensitySegment({
    required List<VisualIntensity> values,
    required List<String> labels,
    required VisualIntensity selected,
    required dynamic colors,
    required ValueChanged<VisualIntensity> onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withOpacity(0.12)),
      ),
      child: Row(
        children: List.generate(values.length, (idx) {
          final val = values[idx];
          final label = labels[idx];
          final isSelected = val == selected;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(val),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary.withOpacity(0.22) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected ? Border.all(color: colors.primary) : null,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
