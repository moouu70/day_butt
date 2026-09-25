import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/providers/theme_provider.dart';

class GlassCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? blur;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final BoxShadow? glow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.blur,
    this.onTap,
    this.gradient,
    this.glow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final glass = theme.glass;
    final colors = theme.colors;

    final effectiveRadius = borderRadius ?? glass.cornerRadius;
    final effectiveBlur = blur ?? glass.blur;
    final effectiveBg = backgroundColor ??
        colors.surface.withOpacity((glass.opacity * 1.5).clamp(0.04, 0.92));
    final effectiveBorderColor = borderColor ?? colors.border;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
        gradient: gradient,
        boxShadow: glow != null
            ? [glow!]
            : (glass.shadowOpacity > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(glass.shadowOpacity),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null),
      ),
      child: child,
    );

    if (effectiveBlur > 0) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
          child: content,
        ),
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
