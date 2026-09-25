import 'package:flutter/services.dart';

class VibrationService {
  static const MethodChannel _channel = MethodChannel('app.day_butt/vibration');

  /// Distinct, physical hardware vibration for tab navigation (45ms)
  static Future<void> vibrateTab() async {
    try {
      await _channel.invokeMethod('vibrate', {'duration': 45, 'amplitude': 255});
    } catch (_) {}
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
    try {
      await HapticFeedback.vibrate();
    } catch (_) {}
  }

  /// Crisp ratchet click for radial wheel scrolling (18ms)
  static Future<void> vibrateTick() async {
    try {
      await _channel.invokeMethod('vibrate', {'duration': 18, 'amplitude': 180});
    } catch (_) {}
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Medium vibration for opening radial menu or pressing hub (35ms)
  static Future<void> vibratePress() async {
    try {
      await _channel.invokeMethod('vibrate', {'duration': 35, 'amplitude': 220});
    } catch (_) {}
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }
}
