import 'background_mode.dart';

class GlassSettings {
  final double opacity;
  final double blur;
  final double borderOpacity;
  final double cornerRadius;
  final double shadowOpacity;

  const GlassSettings({
    required this.opacity,
    required this.blur,
    required this.borderOpacity,
    this.cornerRadius = 20,
    required this.shadowOpacity,
  });

  GlassSettings copyWith({
    double? opacity,
    double? blur,
    double? borderOpacity,
    double? cornerRadius,
    double? shadowOpacity,
  }) {
    return GlassSettings(
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
    );
  }

  GlassSettings applyIntensity(VisualIntensity intensity) {
    switch (intensity) {
      case VisualIntensity.off:
      case VisualIntensity.low:
        return copyWith(
          opacity: 0.04,
          blur: 6,
          borderOpacity: 0.06,
          shadowOpacity: 0.10,
        );
      case VisualIntensity.medium:
        return copyWith(
          opacity: 0.08,
          blur: 16,
          borderOpacity: 0.12,
          shadowOpacity: 0.22,
        );
      case VisualIntensity.high:
        return copyWith(
          opacity: 0.14,
          blur: 24,
          borderOpacity: 0.18,
          shadowOpacity: 0.35,
        );
    }
  }

  GlassSettings applyBlur(VisualIntensity intensity) {
    switch (intensity) {
      case VisualIntensity.off:
        return copyWith(blur: 0);
      case VisualIntensity.low:
        return copyWith(blur: 6);
      case VisualIntensity.medium:
        return copyWith(blur: 16);
      case VisualIntensity.high:
        return copyWith(blur: 26);
    }
  }
}
