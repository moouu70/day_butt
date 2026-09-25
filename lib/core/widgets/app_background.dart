import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/models/background_mode.dart';
import '../theme/models/background_slot.dart';
import '../theme/providers/theme_provider.dart';

class AppBackground extends ConsumerWidget {
  final Widget child;
  final BackgroundSlot slot;
  final double? overlayOpacity;

  const AppBackground({
    super.key,
    required this.child,
    this.slot = BackgroundSlot.home,
    this.overlayOpacity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final bgMode = theme.backgroundMode;
    final colors = theme.colors;
    final effectiveOpacity = (overlayOpacity ?? theme.overlayOpacity).clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Base Solid Color / Ambient Atmosphere Gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: colors.background,
              gradient: bgMode != BackgroundMode.none
                  ? theme.basePreset.previewGradient
                  : null,
            ),
          ),
        ),

        // 2. Image Layer (if enabled and applicable)
        if (theme.showBackgroundImage &&
            (bgMode == BackgroundMode.image || bgMode == BackgroundMode.imageWithOverlay)) ...[
          Positioned.fill(
            child: _buildImageLayer(theme),
          ),
        ],

        // 3. Contrast Overlay Layer (ensures accessibility & crisp readability)
        if (bgMode == BackgroundMode.imageWithOverlay && theme.showBackgroundImage) ...[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.background.withOpacity((effectiveOpacity * 0.88).clamp(0.0, 1.0)),
                    colors.background.withOpacity(effectiveOpacity),
                    colors.background.withOpacity((effectiveOpacity * 0.95).clamp(0.0, 1.0)),
                  ],
                ),
              ),
            ),
          ),
        ],

        // 4. Subtle Radial Atmospheric Glow (theme-aware)
        if (theme.glow.enabled && theme.glow.intensity > 0) ...[
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.primary.withOpacity((theme.glow.intensity * 0.25).clamp(0.0, 1.0)),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],

        // 5. Foreground Content
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _buildImageLayer(dynamic theme) {
    final bgPath = theme.getEffectiveBackground(slot);
    if (bgPath == null || bgPath.isEmpty) {
      return Container(
        decoration: BoxDecoration(gradient: theme.basePreset.previewGradient),
      );
    }

    final isCustom = theme.isCustomImage(slot);

    if (isCustom && !kIsWeb) {
      try {
        final file = File(bgPath);
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: theme.basePreset.previewGradient),
          ),
        );
      } catch (_) {
        return Container(
          decoration: BoxDecoration(gradient: theme.basePreset.previewGradient),
        );
      }
    }

    return Image.asset(
      bgPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: BoxDecoration(gradient: theme.basePreset.previewGradient),
      ),
    );
  }
}
