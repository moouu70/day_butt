import 'background_mode.dart';

class GlowSettings {
  final bool enabled;
  final double intensity;
  final double radius;

  const GlowSettings({
    required this.enabled,
    required this.intensity,
    required this.radius,
  });

  GlowSettings copyWith({
    bool? enabled,
    double? intensity,
    double? radius,
  }) {
    return GlowSettings(
      enabled: enabled ?? this.enabled,
      intensity: intensity ?? this.intensity,
      radius: radius ?? this.radius,
    );
  }

  GlowSettings applyIntensity(VisualIntensity level) {
    switch (level) {
      case VisualIntensity.off:
        return const GlowSettings(enabled: false, intensity: 0.0, radius: 0.0);
      case VisualIntensity.low:
        return const GlowSettings(enabled: true, intensity: 0.15, radius: 8.0);
      case VisualIntensity.medium:
        return const GlowSettings(enabled: true, intensity: 0.30, radius: 14.0);
      case VisualIntensity.high:
        return const GlowSettings(enabled: true, intensity: 0.50, radius: 22.0);
    }
  }
}
