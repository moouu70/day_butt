import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/vibration_service.dart';
import '../../../../core/theme/models/background_mode.dart';
import '../../../../core/theme/models/background_slot.dart';
import '../../../../core/theme/providers/theme_provider.dart';

class BackgroundCustomizer extends ConsumerStatefulWidget {
  const BackgroundCustomizer({super.key});

  @override
  ConsumerState<BackgroundCustomizer> createState() => _BackgroundCustomizerState();
}

class _BackgroundCustomizerState extends ConsumerState<BackgroundCustomizer> {
  BackgroundSlot _selectedSlot = BackgroundSlot.home;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BackgroundSlot slot) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (file != null) {
        VibrationService.vibrateTab();
        ref.read(themeProvider.notifier).setCustomSlotImage(slot, file.path);
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      if (mounted) {
        final colors = ref.read(effectiveThemeProvider).colors;
        final loc = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc.isArabic
                  ? 'تعذر فتح المعرض. يرجى التحقق من أذونات الصور.'
                  : 'Unable to open gallery. Please check photo permissions.',
              style: TextStyle(color: colors.textPrimary),
            ),
            backgroundColor: colors.surfaceElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _confirmClearAllCustom(BuildContext context, AppLocalizations loc, dynamic colors) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border.withOpacity(0.2)),
        ),
        title: Text(
          loc.isArabic ? 'مسح الخلفيات المخصصة' : 'Clear Custom Backgrounds',
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700),
        ),
        content: Text(
          loc.isArabic
              ? 'هل أنت متأكد من مسح جميع الصور المخصصة واستعادة خلفيات الثيم الافتراضية؟'
              : 'Are you sure you want to remove all custom backgrounds and restore the theme defaults?',
          style: TextStyle(color: colors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.tr('cancel'), style: TextStyle(color: colors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              VibrationService.vibratePress();
              ref.read(themeProvider.notifier).clearAllCustomSlotImages();
            },
            child: Text(
              loc.isArabic ? 'مسح الكل' : 'Clear All',
              style: TextStyle(color: colors.danger, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _getSlotLabel(BackgroundSlot slot, AppLocalizations loc) {
    switch (slot) {
      case BackgroundSlot.home:
        return loc.tr('home');
      case BackgroundSlot.university:
        return loc.tr('university');
      case BackgroundSlot.calories:
        return loc.tr('calories');
      case BackgroundSlot.expenses:
        return loc.tr('expenses');
      case BackgroundSlot.routine:
        return loc.tr('routines');
      case BackgroundSlot.notes:
        return loc.isArabic ? 'الملاحظات' : 'Notes';
      case BackgroundSlot.settings:
        return loc.tr('settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(effectiveThemeProvider);
    final themeState = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isArabic = loc.isArabic;
    final colors = theme.colors;

    final currentMode = theme.backgroundMode;
    final customSlotImages = themeState.overrides.customSlotImages;
    final currentCustomPath = customSlotImages[_selectedSlot];
    final hasCustomOnCurrentSlot = currentCustomPath != null &&
        (!kIsWeb ? File(currentCustomPath).existsSync() : true);
    final hasAnyCustomImages = customSlotImages.isNotEmpty;
    final defaultThemeAsset = theme.backgrounds.forSlot(_selectedSlot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Selector: Minimal, Cinematic, None
        Row(
          children: [
            _buildModeCard(
              mode: BackgroundMode.solid,
              label: loc.tr('minimal'),
              icon: LucideIcons.palette,
              isSelected: currentMode == BackgroundMode.solid,
              colors: colors,
              onTap: () {
                VibrationService.vibrateTab();
                notifier.setBackgroundMode(BackgroundMode.solid);
              },
            ),
            const SizedBox(width: 8),
            _buildModeCard(
              mode: BackgroundMode.imageWithOverlay,
              label: loc.tr('cinematic'),
              icon: LucideIcons.sparkles,
              isSelected: currentMode == BackgroundMode.imageWithOverlay,
              colors: colors,
              onTap: () {
                VibrationService.vibrateTab();
                notifier.setBackgroundMode(BackgroundMode.imageWithOverlay);
              },
            ),
            const SizedBox(width: 8),
            _buildModeCard(
              mode: BackgroundMode.none,
              label: loc.tr('none'),
              icon: LucideIcons.ban,
              isSelected: currentMode == BackgroundMode.none,
              colors: colors,
              onTap: () {
                VibrationService.vibrateTab();
                notifier.setBackgroundMode(BackgroundMode.none);
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Screen Backgrounds Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.tr('screenBackgrounds'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            if (hasAnyCustomImages)
              GestureDetector(
                onTap: () => _confirmClearAllCustom(context, loc, colors),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.danger.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.danger.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.rotateCcw, size: 12, color: colors.danger),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'استعادة كل الافتراضيات' : 'Clear Custom',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Slots Horizontal Selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: BackgroundSlot.values.map((slot) {
              final isSelected = slot == _selectedSlot;
              final slotHasCustom = customSlotImages.containsKey(slot);

              return GestureDetector(
                onTap: () {
                  VibrationService.vibrateTab();
                  setState(() => _selectedSlot = slot);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withOpacity(0.2)
                        : colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colors.primary
                          : colors.border.withOpacity(0.14),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (slotHasCustom)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        _getSlotLabel(slot, loc),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? colors.primary : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Two Source Options: Built-in Theme Default vs User Custom Image
        Row(
          children: [
            // 1. BUILT-IN THEME DEFAULT CARD
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (hasCustomOnCurrentSlot) {
                    VibrationService.vibrateTab();
                    notifier.removeCustomSlotImage(_selectedSlot);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 130,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: !hasCustomOnCurrentSlot
                          ? colors.primary
                          : colors.border.withOpacity(0.15),
                      width: !hasCustomOnCurrentSlot ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      if (!hasCustomOnCurrentSlot)
                        BoxShadow(
                          color: colors.primary.withOpacity(0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        // Background asset or solid
                        Positioned.fill(
                          child: defaultThemeAsset != null
                              ? Image.asset(
                                  defaultThemeAsset,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: colors.surfaceSecondary,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: theme.basePreset.previewGradient,
                                  ),
                                ),
                        ),
                        // Overlay gradient for readability
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.85),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Status Badge
                        Positioned(
                          top: 8,
                          left: isArabic ? null : 8,
                          right: isArabic ? 8 : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: !hasCustomOnCurrentSlot
                                  ? colors.primary
                                  : Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!hasCustomOnCurrentSlot) ...[
                                  const Icon(LucideIcons.check, size: 10, color: Colors.white),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  isArabic ? 'ثيم افتراضي' : 'Theme Default',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Label at bottom
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            theme.basePreset.getName(isArabic),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. USER CUSTOM IMAGE CARD
            Expanded(
              child: GestureDetector(
                onTap: () => _pickImage(_selectedSlot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 130,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasCustomOnCurrentSlot
                          ? colors.primary
                          : colors.border.withOpacity(0.15),
                      width: hasCustomOnCurrentSlot ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      if (hasCustomOnCurrentSlot)
                        BoxShadow(
                          color: colors.primary.withOpacity(0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        if (hasCustomOnCurrentSlot && !kIsWeb)
                          Positioned.fill(
                            child: Image.file(
                              File(currentCustomPath),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: colors.surfaceSecondary,
                                child: Center(
                                  child: Icon(LucideIcons.imageOff, size: 24, color: colors.textMuted),
                                ),
                              ),
                            ),
                          )
                        else
                          Positioned.fill(
                            child: Container(
                              color: colors.surfaceSecondary.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.imagePlus, size: 24, color: colors.textMuted),
                                  const SizedBox(height: 6),
                                  Text(
                                    isArabic ? 'اختر صورة' : 'Pick Image',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        // Dark overlay if image is loaded
                        if (hasCustomOnCurrentSlot)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.85),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // Custom badge
                        Positioned(
                          top: 8,
                          left: isArabic ? null : 8,
                          right: isArabic ? 8 : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: hasCustomOnCurrentSlot
                                  ? colors.primary
                                  : Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (hasCustomOnCurrentSlot) ...[
                                  const Icon(LucideIcons.check, size: 10, color: Colors.white),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  isArabic ? 'مخصصة' : 'Custom Image',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Bottom Label
                        if (hasCustomOnCurrentSlot)
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              isArabic ? 'صورة المعرض' : 'Gallery Image',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Actions: Choose from Gallery & (if custom active) Use Theme Default
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickImage(_selectedSlot),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.primary.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.image, size: 15, color: colors.primary),
                      const SizedBox(width: 8),
                      Text(
                        loc.tr('chooseCustomImage'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (hasCustomOnCurrentSlot) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  VibrationService.vibrateTab();
                  notifier.removeCustomSlotImage(_selectedSlot);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: colors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.rotateCcw, size: 14, color: colors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'استعادة الافتراضي' : 'Use Default',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required BackgroundMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
    required dynamic colors,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary.withOpacity(0.2) : colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? colors.primary : colors.border.withOpacity(0.14),
              width: isSelected ? 1.6 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? colors.primary : colors.textSecondary,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
