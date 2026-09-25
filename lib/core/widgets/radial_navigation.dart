import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/vibration_service.dart';
import '../theme/resolver/effective_theme_provider.dart';

class RadialNavItem {
  final int index;
  final String labelKey;
  final String labelFallback;
  final IconData icon;
  final double angleDeg; // Angle in degrees where 0 is right, -90 is straight up

  const RadialNavItem({
    required this.index,
    required this.labelKey,
    required this.labelFallback,
    required this.icon,
    required this.angleDeg,
  });

  double effectiveAngle(bool isRtl) {
    if (!isRtl) return angleDeg;
    // Mirror across the vertical axis (-90 degrees) for natural RTL reading order
    return -180.0 - angleDeg;
  }
}

class _HapticsEngine {
  int _lastTriggerTime = 0;

  Future<bool> trigger(String reason) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (reason == 'wheel-rotate' && now - _lastTriggerTime < 65) {
      return false;
    }
    _lastTriggerTime = now;

    try {
      if (reason == 'navigation') {
        await VibrationService.vibrateTab();
      } else if (reason == 'wheel-rotate') {
        await VibrationService.vibrateTick();
      } else if (reason == 'menu-open') {
        await VibrationService.vibratePress();
      } else if (reason == 'menu-close') {
        await HapticFeedback.lightImpact();
      } else {
        await HapticFeedback.selectionClick();
      }
    } catch (_) {}
    return true;
  }
}

final _haptics = _HapticsEngine();

class RadialFloatingNavigation extends ConsumerStatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final String Function(String key, String fallback)? labelTranslator;

  const RadialFloatingNavigation({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    this.labelTranslator,
  });

  @override
  ConsumerState<RadialFloatingNavigation> createState() => _RadialFloatingNavigationState();
}

class _RadialFloatingNavigationState extends ConsumerState<RadialFloatingNavigation>
    with TickerProviderStateMixin {
  late final AnimationController _expandCtrl;
  late final AnimationController _hubCtrl;

  bool _isOpen = false;
  bool _isPressingHub = false;
  bool _isDragging = false;
  bool _wasOpenBeforePress = false;
  Offset? _origin;
  late int _highlightIndex;

  static const double _hubDiameter = 58.0;
  static const double _hubRadius = _hubDiameter / 2;
  static const double _nodeDiameter = 48.0;
  static const double _nodeRadius = _nodeDiameter / 2;
  static const double _radialDistance = 114.0;
  static const double _dotRadius = 76.0;
  static const double _deadzone = 22.0;

  static const SpringDescription _expandSpring = SpringDescription(
    mass: 1.0,
    stiffness: 72.0,
    damping: 7.8,
  );

  static const SpringDescription _hubSpring = SpringDescription(
    mass: 1.0,
    stiffness: 48.0,
    damping: 6.8,
  );

  // 5 Destinations fanned out across the top semi-circle
  static const List<RadialNavItem> _items = [
    RadialNavItem(
      index: 0,
      labelKey: 'navCalories',
      labelFallback: 'Calories',
      icon: LucideIcons.flame,
      angleDeg: -162.0,
    ),
    RadialNavItem(
      index: 1,
      labelKey: 'navUni',
      labelFallback: 'Uni',
      icon: LucideIcons.graduationCap,
      angleDeg: -126.0,
    ),
    RadialNavItem(
      index: 2,
      labelKey: 'navHome',
      labelFallback: 'Home',
      icon: LucideIcons.home,
      angleDeg: -90.0,
    ),
    RadialNavItem(
      index: 3,
      labelKey: 'navExpenses',
      labelFallback: 'Expenses',
      icon: LucideIcons.wallet,
      angleDeg: -54.0,
    ),
    RadialNavItem(
      index: 4,
      labelKey: 'navRoutine',
      labelFallback: 'Routine',
      icon: LucideIcons.checkCircle2,
      angleDeg: -18.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _highlightIndex = widget.currentIndex;
    _expandCtrl = AnimationController(vsync: this, value: 0.0);
    _hubCtrl = AnimationController(vsync: this, value: 1.0);
  }

  @override
  void didUpdateWidget(covariant RadialFloatingNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _highlightIndex = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _hubCtrl.dispose();
    super.dispose();
  }

  void _animateExpand(bool open) {
    _isOpen = open;
    _expandCtrl.animateWith(
      SpringSimulation(
        _expandSpring,
        _expandCtrl.value,
        open ? 1.0 : 0.0,
        0,
      ),
    );
  }

  void _animateHubScale(double target) {
    _hubCtrl.animateWith(
      SpringSimulation(_hubSpring, _hubCtrl.value, target, 0),
    );
  }

  void _setPressing(bool pressing) {
    if (_isPressingHub == pressing) return;
    _isPressingHub = pressing;
    _animateHubScale(pressing ? 0.93 : 1.0);
  }

  void _openMenu() {
    _haptics.trigger('menu-open');
    _highlightIndex = widget.currentIndex;
    setState(() => _isOpen = true);
    _animateExpand(true);
  }

  void _closeMenu() {
    _haptics.trigger('menu-close');
    setState(() => _isOpen = false);
    _animateExpand(false);
  }

  void _selectItem(int index) {
    _haptics.trigger('navigation');
    _highlightIndex = index;
    widget.onSelect(index);
    setState(() => _isOpen = false);
    _animateExpand(false);
  }

  double _normalizeAngle(double angle) {
    while (angle > 180) {
      angle -= 360;
    }
    while (angle < -180) {
      angle += 360;
    }
    return angle;
  }

  void _onPointerDown(PointerDownEvent event) {
    _wasOpenBeforePress = _isOpen;
    _origin = event.position;
    _isDragging = false;
    _setPressing(true);

    if (!_isOpen) {
      _openMenu();
    }
  }

  void _onPointerMove(PointerMoveEvent event, bool isRtl) {
    if (_origin == null) return;
    final delta = event.position - _origin!;
    if (delta.distance >= _deadzone) {
      _isDragging = true;
      _handleDragMove(delta, isRtl);
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_origin == null) return;
    final delta = event.position - _origin!;
    _setPressing(false);
    _origin = null;

    if (_isDragging && delta.distance >= _deadzone) {
      _selectItem(_highlightIndex);
    } else {
      // Tap on hub
      if (_wasOpenBeforePress) {
        _closeMenu();
      }
    }
    _isDragging = false;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _setPressing(false);
    _origin = null;
    _isDragging = false;
  }

  void _handleDragMove(Offset delta, bool isRtl) {
    final angleDeg = math.atan2(delta.dy, delta.dx) * 180 / math.pi;
    var closest = _items.first;
    var minDiff = 360.0;

    for (final item in _items) {
      final effAngle = item.effectiveAngle(isRtl);
      final diff = _normalizeAngle(angleDeg - effAngle).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = item;
      }
    }

    if (closest.index != _highlightIndex) {
      setState(() => _highlightIndex = closest.index);
      _haptics.trigger('wheel-rotate');
    }
  }

  IconData _getCurrentHubIcon() {
    if (widget.currentIndex >= 0 && widget.currentIndex < _items.length) {
      return _items[widget.currentIndex].icon;
    }
    return LucideIcons.layoutGrid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final primaryColor = colors.primary;
    final secondaryColor = colors.secondary;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final bottomOffset = 24.0 + bottomInset;

    return AnimatedBuilder(
      animation: Listenable.merge([_expandCtrl, _hubCtrl]),
      builder: (context, _) {
        final progress = _expandCtrl.value;
        final isMenuVisible = _isOpen || progress > 0.01;

        return Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Full backdrop scrim when menu is open
            if (isMenuVisible)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _closeMenu,
                  child: Container(
                    color: Colors.black.withOpacity(0.50 * progress.clamp(0.0, 1.0)),
                  ),
                ),
              ),

            // Dashed radial arcs & connecting spokes painter
            if (isMenuVisible)
              Positioned(
                bottom: bottomOffset + _hubRadius,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: progress.clamp(0.0, 1.0),
                    child: CustomPaint(
                      painter: _RadialLayerPainter(
                        activeItemIndex: _highlightIndex,
                        items: _items,
                        radialDistance: _radialDistance,
                        dotRadius: _dotRadius,
                        hubRadius: _hubRadius,
                        nodeRadius: _nodeRadius,
                        progress: progress,
                        isRtl: isRtl,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        borderColor: colors.border,
                      ),
                    ),
                  ),
                ),
              ),

            // Radial Navigation Nodes
            if (isMenuVisible)
              ..._items.map((item) {
                final angle = item.effectiveAngle(isRtl);
                final rad = angle * math.pi / 180;
                final dist = _radialDistance * progress;
                final dx = dist * math.cos(rad);
                final dy = dist * math.sin(rad); // dy is negative upwards

                final isHighlighted = _highlightIndex == item.index;
                final isSelected = widget.currentIndex == item.index;
                final targetScale = isHighlighted ? 1.14 : (isSelected ? 1.05 : 1.0);
                final scale = (0.35 + (targetScale - 0.35) * progress).clamp(0.0, 1.25);

                final label = widget.labelTranslator?.call(item.labelKey, item.labelFallback) ??
                    item.labelFallback;

                return Positioned(
                  bottom: bottomOffset + _hubRadius - _nodeRadius - dy,
                  child: Transform.translate(
                    offset: Offset(dx, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: progress.clamp(0.0, 1.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _selectItem(item.index),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOutCubic,
                                width: _nodeDiameter,
                                height: _nodeDiameter,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isHighlighted
                                      ? primaryColor.withOpacity(0.35)
                                      : (isSelected
                                          ? primaryColor.withOpacity(0.25)
                                          : colors.surface.withOpacity(0.9)),
                                  border: Border.all(
                                    color: isHighlighted
                                        ? secondaryColor
                                        : (isSelected
                                            ? primaryColor
                                            : colors.border),
                                    width: isHighlighted ? 2.0 : 1.2,
                                  ),
                                  boxShadow: isHighlighted
                                      ? [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.65),
                                            blurRadius: 24,
                                            offset: const Offset(0, 4),
                                          ),
                                          BoxShadow(
                                            color: secondaryColor.withOpacity(0.35),
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.45),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Center(
                                  child: Icon(
                                    item.icon,
                                    size: 21,
                                    color: isHighlighted
                                        ? Colors.white
                                        : (isSelected
                                            ? secondaryColor
                                            : colors.textMuted),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isHighlighted
                                      ? primaryColor.withOpacity(0.9)
                                      : colors.surface.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isHighlighted
                                        ? secondaryColor.withOpacity(0.6)
                                        : colors.border.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isHighlighted
                                        ? Colors.white
                                        : (isSelected
                                            ? secondaryColor
                                            : colors.textMuted),
                                    fontSize: 10.5,
                                    fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

            // Floating Central Hub Button with Drag-to-Select Listener
            Positioned(
              bottom: bottomOffset,
              child: Listener(
                onPointerDown: _onPointerDown,
                onPointerMove: (e) => _onPointerMove(e, isRtl),
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                child: Transform.scale(
                  scale: _hubCtrl.value,
                  child: Container(
                    width: _hubDiameter,
                    height: _hubDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.4),
                        radius: 1.3,
                        colors: [
                          primaryColor.withOpacity(0.35),
                          colors.surfaceSecondary,
                          colors.surface,
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                      border: Border.all(
                        color: _isPressingHub
                            ? secondaryColor
                            : (_isOpen
                                ? primaryColor
                                : primaryColor.withOpacity(0.7)),
                        width: _isPressingHub ? 2.0 : 1.5,
                      ),
                      boxShadow: [
                        if (!_isOpen || _isPressingHub)
                          BoxShadow(
                            color: _isPressingHub
                                ? secondaryColor.withOpacity(0.6)
                                : primaryColor.withOpacity(0.35),
                            blurRadius: _isPressingHub ? 36 : 22,
                            offset: const Offset(0, 4),
                          ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.65),
                          offset: const Offset(0, 6),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Inner concentric decorative ring
                        Container(
                          width: _hubDiameter - 14,
                          height: _hubDiameter - 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 1.0,
                            ),
                          ),
                        ),
                        // Center icon with smooth rotation on state change
                        AnimatedRotation(
                          turns: _isOpen ? 0.125 : 0.0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            _isOpen ? LucideIcons.x : _getCurrentHubIcon(),
                            size: 22,
                            color: _isOpen ? Colors.white : secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RadialLayerPainter extends CustomPainter {
  final int activeItemIndex;
  final List<RadialNavItem> items;
  final double radialDistance;
  final double dotRadius;
  final double hubRadius;
  final double nodeRadius;
  final double progress;
  final bool isRtl;
  final Color primaryColor;
  final Color secondaryColor;
  final Color borderColor;

  _RadialLayerPainter({
    required this.activeItemIndex,
    required this.items,
    required this.radialDistance,
    required this.dotRadius,
    required this.hubRadius,
    required this.nodeRadius,
    required this.progress,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const center = Offset.zero;

    // Outer guide arc along radial distance
    final ringPaint1 = Paint()
      ..color = borderColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    _dashedArc(canvas, center, radialDistance * progress, -172, 164, ringPaint1, 4, 5);

    // Inner dot guide arc
    final ringPaint2 = Paint()
      ..color = borderColor.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    _dashedArc(canvas, center, dotRadius * progress, -172, 164, ringPaint2, 3, 4);

    for (final item in items) {
      final isHighlighted = activeItemIndex == item.index;
      final rad = item.effectiveAngle(isRtl) * math.pi / 180;
      final cosA = math.cos(rad);
      final sinA = math.sin(rad);

      final p1 = Offset(hubRadius * cosA, hubRadius * sinA);
      final p2 = Offset(
        (radialDistance - nodeRadius) * progress * cosA,
        (radialDistance - nodeRadius) * progress * sinA,
      );

      final linePaint = Paint()
        ..color = isHighlighted
            ? secondaryColor
            : borderColor.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isHighlighted ? 2.2 : 1.2
        ..strokeCap = StrokeCap.round;

      if (isHighlighted) {
        canvas.drawLine(p1, p2, linePaint);
      } else {
        _dashedLine(canvas, p1, p2, linePaint, 4, 4);
      }

      final dotPos = Offset(
        dotRadius * progress * cosA,
        dotRadius * progress * sinA,
      );

      if (isHighlighted) {
        canvas.drawCircle(
          dotPos,
          6.0,
          Paint()
            ..color = primaryColor.withOpacity(0.35)
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          dotPos,
          4.0,
          Paint()
            ..color = secondaryColor
            ..style = PaintingStyle.fill,
        );
      } else {
        canvas.drawCircle(
          dotPos,
          3.0,
          Paint()
            ..color = primaryColor.withOpacity(0.3)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  void _dashedArc(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngleDeg,
    double sweepAngleDeg,
    Paint paint,
    double dash,
    double gap,
  ) {
    if (radius <= 0) return;
    final startRad = startAngleDeg * math.pi / 180;
    final sweepRad = sweepAngleDeg * math.pi / 180;
    final path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        startRad,
        sweepRad,
      );
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + gap;
      }
    }
  }

  void _dashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Paint paint,
    double dash,
    double gap,
  ) {
    final total = (b - a).distance;
    if (total <= 0) return;
    final dir = (b - a) / total;
    double distance = 0;
    while (distance < total) {
      final end = math.min(distance + dash, total);
      canvas.drawLine(a + dir * distance, a + dir * end, paint);
      distance = end + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _RadialLayerPainter oldDelegate) =>
      oldDelegate.activeItemIndex != activeItemIndex ||
      oldDelegate.progress != progress ||
      oldDelegate.isRtl != isRtl ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.borderColor != borderColor;
}
