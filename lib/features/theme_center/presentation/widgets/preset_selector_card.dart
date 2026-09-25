import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/models/app_theme_preset.dart';
import '../../../../core/theme/providers/theme_provider.dart';

class PresetSelectorCard extends ConsumerWidget {
  final AppThemePreset preset;
  final bool isSelected;
  final VoidCallback onSelect;

  const PresetSelectorCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final loc = AppLocalizations.of(context);
    final isArabic = loc.isArabic;
    final currentColors = theme.colors;
    final presetColors = preset.colors;
    final topAsset = preset.backgrounds.home;

    return GestureDetector(
      onTap: () {
        VibrationService.vibrateTab();
        onSelect();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected
              ? presetColors.surface.withOpacity(0.9)
              : currentColors.surface.withOpacity(0.65),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? presetColors.primary
                : currentColors.border.withOpacity(0.14),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: presetColors.primary.withOpacity(0.28),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Visual Theme Preview Area
              Expanded(
                child: Stack(
                  children: [
                    // Background base (asset or solid)
                    Positioned.fill(
                      child: topAsset != null
                          ? Image.asset(
                              topAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: presetColors.background,
                              ),
                            )
                          : Container(color: presetColors.background),
                    ),
                    // Darkening overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              presetColors.background.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Miniature Glass Card + Accents Preview
                    Center(
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: presetColors.surface.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: presetColors.border.withOpacity(0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: presetColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: presetColors.primary.withOpacity(0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: presetColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: presetColors.highlight,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Selected Check Badge
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: isArabic ? null : 8,
                        left: isArabic ? 8 : null,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: presetColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: presetColors.primary.withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom Label Area
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        preset.getName(isArabic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? currentColors.textPrimary
                              : currentColors.textPrimary.withOpacity(0.85),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Text(
                        loc.tr('applied'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: presetColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
