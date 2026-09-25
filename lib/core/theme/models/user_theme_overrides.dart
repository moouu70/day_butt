import 'package:flutter/material.dart';
import 'background_mode.dart';
import 'background_slot.dart';

class UserThemeOverrides {
  final Color? customAccent;
  final VisualIntensity? glassIntensity;
  final VisualIntensity? blurIntensity;
  final VisualIntensity? glowIntensity;
  final BackgroundMode? backgroundMode;
  final Map<BackgroundSlot, String> slotBackgrounds;
  final Map<BackgroundSlot, String> customSlotImages;

  const UserThemeOverrides({
    this.customAccent,
    this.glassIntensity,
    this.blurIntensity,
    this.glowIntensity,
    this.backgroundMode,
    this.slotBackgrounds = const {},
    this.customSlotImages = const {},
  });

  static const UserThemeOverrides empty = UserThemeOverrides();

  bool get isEmpty =>
      customAccent == null &&
      glassIntensity == null &&
      blurIntensity == null &&
      glowIntensity == null &&
      backgroundMode == null &&
      slotBackgrounds.isEmpty &&
      customSlotImages.isEmpty;

  UserThemeOverrides copyWith({
    Color? customAccent,
    bool clearCustomAccent = false,
    VisualIntensity? glassIntensity,
    VisualIntensity? blurIntensity,
    VisualIntensity? glowIntensity,
    BackgroundMode? backgroundMode,
    Map<BackgroundSlot, String>? slotBackgrounds,
    Map<BackgroundSlot, String>? customSlotImages,
  }) {
    return UserThemeOverrides(
      customAccent: clearCustomAccent ? null : (customAccent ?? this.customAccent),
      glassIntensity: glassIntensity ?? this.glassIntensity,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      backgroundMode: backgroundMode ?? this.backgroundMode,
      slotBackgrounds: slotBackgrounds ?? this.slotBackgrounds,
      customSlotImages: customSlotImages ?? this.customSlotImages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (customAccent != null) 'accent': '#${customAccent!.value.toRadixString(16).padLeft(8, '0')}',
      if (glassIntensity != null) 'glassIntensity': glassIntensity!.name,
      if (blurIntensity != null) 'blur': blurIntensity!.name,
      if (glowIntensity != null) 'glow': glowIntensity!.name,
      if (backgroundMode != null) 'backgroundMode': backgroundMode!.name,
      if (slotBackgrounds.isNotEmpty)
        'slotBackgrounds': slotBackgrounds.map((k, v) => MapEntry(k.name, v)),
      if (customSlotImages.isNotEmpty)
        'customSlotImages': customSlotImages.map((k, v) => MapEntry(k.name, v)),
    };
  }

  factory UserThemeOverrides.fromJson(Map<String, dynamic> json) {
    Color? accent;
    if (json['accent'] is String) {
      final hex = (json['accent'] as String).replaceAll('#', '');
      final val = int.tryParse(hex, radix: 16);
      if (val != null) {
        accent = Color(val.toSigned(32));
      }
    }

    VisualIntensity? parseIntensity(String? name) {
      if (name == null) return null;
      for (final v in VisualIntensity.values) {
        if (v.name == name) return v;
      }
      return null;
    }

    BackgroundMode? parseMode(String? name) {
      if (name == null) return null;
      for (final m in BackgroundMode.values) {
        if (m.name == name) return m;
      }
      return null;
    }

    final slotBgs = <BackgroundSlot, String>{};
    if (json['slotBackgrounds'] is Map) {
      final map = json['slotBackgrounds'] as Map;
      for (final entry in map.entries) {
        final slot = BackgroundSlot.values.cast<BackgroundSlot?>().firstWhere(
              (s) => s?.name == entry.key,
              orElse: () => null,
            );
        if (slot != null && entry.value is String) {
          slotBgs[slot] = entry.value as String;
        }
      }
    }

    final customImages = <BackgroundSlot, String>{};
    if (json['customSlotImages'] is Map) {
      final map = json['customSlotImages'] as Map;
      for (final entry in map.entries) {
        final slot = BackgroundSlot.values.cast<BackgroundSlot?>().firstWhere(
              (s) => s?.name == entry.key,
              orElse: () => null,
            );
        if (slot != null && entry.value is String) {
          customImages[slot] = entry.value as String;
        }
      }
    }

    return UserThemeOverrides(
      customAccent: accent,
      glassIntensity: parseIntensity(json['glassIntensity'] as String?),
      blurIntensity: parseIntensity(json['blur'] as String?),
      glowIntensity: parseIntensity(json['glow'] as String?),
      backgroundMode: parseMode(json['backgroundMode'] as String?),
      slotBackgrounds: slotBgs,
      customSlotImages: customImages,
    );
  }
}
