import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/models/theme_colors.dart';
import '../../../../core/theme/providers/theme_provider.dart';

class CalorieRingGauge extends ConsumerWidget {
  final int currentCalories;
  final int targetCalories;
  final double size;

  const CalorieRingGauge({
    super.key,
    required this.currentCalories,
    this.targetCalories = 2300,
    this.size = 230,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final progress = targetCalories > 0
        ? (currentCalories / targetCalories).clamp(0.0, 1.0)
        : 0.0;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size),
              painter: _RingPainter(
                progress: progress,
                colors: colors,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.caloriesAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.flame,
                    size: 24,
                    color: colors.caloriesAccent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  NumberFormatCompat.format(currentCalories),
                  style: AppTypography.dashboardNumber.copyWith(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  'kcal',
                  style: AppTypography.cardSubtitle.copyWith(
                    color: colors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Today',
                  style: AppTypography.metadata.copyWith(
                    color: colors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final ThemeColors colors;

  _RingPainter({
    required this.progress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 16;
    const strokeWidth = 14.0;

    // Track Paint
    final trackPaint = Paint()
      ..color = colors.surfaceSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // We draw a 280-degree sweep arc starting from 130 degrees
    const startAngle = 130 * (math.pi / 180);
    const totalSweep = 280 * (math.pi / 180);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      trackPaint,
    );

    if (progress > 0) {
      final sweep = totalSweep * progress;

      // Glow paint
      final glowPaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + totalSweep,
          colors: [
            colors.caloriesAccent,
            colors.secondary,
            colors.primary,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        glowPaint,
      );

      // Active Arc Paint
      final activePaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + totalSweep,
          colors: [
            colors.caloriesAccent,
            colors.secondary,
            colors.primary,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.colors != colors;
  }
}

class NumberFormatCompat {
  static String format(int number) {
    final str = number.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }
}
