import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/providers/calorie_goal_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../calories/presentation/widgets/edit_calorie_goal_sheet.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_sheet.dart';
import '../../../database/database_provider.dart';
import '../../../services/backup_service.dart';
import '../../../services/obsidian_service.dart';
import '../../home/presentation/widgets/obsidian_preview_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _exportBackup() async {
    final db = ref.read(databaseProvider);
    final backupJson = await BackupService(db).exportBackupJson();
    final colors = ref.read(effectiveThemeProvider).colors;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border),
        ),
        title: Text(AppLocalizations.of(context).tr('exportJson'), style: AppTypography.sectionTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).tr('exportJsonDesc'),
                style: AppTypography.bodyMuted,
              ),
              const SizedBox(height: 12),
              Container(
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    backupJson,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context).tr('cancel'), style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: backupJson));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Backup JSON copied to clipboard!'),
                  backgroundColor: colors.success,
                ),
              );
            },
            child: const Text('Copy JSON'),
          ),
        ],
      ),
    );
  }

  void _showImportBackupSheet() {
    final controller = TextEditingController();
    final loc = AppLocalizations.of(context);

    GlassSheet.show(
      context: context,
      title: loc.tr('importJson'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.tr('importJsonDesc'),
            style: AppTypography.bodyMuted,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: controller,
            hintText: '{\n  "version": 1,\n  ...\n}',
            maxLines: 6,
          ),
          const SizedBox(height: 20),
          GlassButton(
            label: loc.tr('save'),
            onPressed: () async {
              final jsonStr = controller.text.trim();
              if (jsonStr.isEmpty) return;

              final db = ref.read(databaseProvider);
              final success = await BackupService(db).importBackupJson(jsonStr);

              if (mounted) {
                Navigator.of(context).pop();
                final colors = ref.read(effectiveThemeProvider).colors;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Backup restored successfully!'
                          : 'Failed to restore backup. Invalid JSON.',
                    ),
                    backgroundColor: success ? colors.success : colors.danger,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    final loc = AppLocalizations.of(context);
    final colors = ref.read(effectiveThemeProvider).colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.dangerGlow),
        ),
        title: Text(loc.tr('clearAllData'), style: TextStyle(color: colors.danger)),
        content: Text(
          loc.tr('confirmClear'),
          style: AppTypography.bodyMuted,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(loc.tr('cancel'), style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(loc.tr('delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await db.clearAllData();
      if (mounted) {
        final colors = ref.read(effectiveThemeProvider).colors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.tr('clearAllDataDesc')),
            backgroundColor: colors.danger,
          ),
        );
      }
    }
  }

  Future<void> _editUserName(String currentName) async {
    final controller = TextEditingController(text: currentName);
    final loc = AppLocalizations.of(context);
    final colors = ref.read(effectiveThemeProvider).colors;
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border),
        ),
        title: Text(loc.isArabic ? 'تعديل الاسم' : 'Edit Name', style: AppTypography.sectionTitle),
        content: AppTextField(
          controller: controller,
          hintText: loc.isArabic ? 'اسمك' : 'Your name',
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.tr('cancel'), style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(loc.tr('save')),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      await ref.read(userNameProvider.notifier).setUserName(newName);
    }
  }

  Future<void> _launchTwitter() async {
    final uri = Uri.parse(AppConstants.developerTwitterUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open ${AppConstants.developerTwitterUrl}')),
        );
      }
    }
  }

  void _showManualPathDialog(String currentPath) {
    final controller = TextEditingController(text: currentPath);
    final loc = AppLocalizations.of(context);
    final colors = ref.read(effectiveThemeProvider).colors;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.border),
        ),
        title: Text(loc.tr('enterPathManually'), style: AppTypography.sectionTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.tr('obsidianFolderDesc'),
              style: AppTypography.bodyMuted,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: controller,
              hintText: loc.tr('obsidianPathHint'),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.tr('cancel'), style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final path = controller.text.trim();
              if (path.isNotEmpty) {
                final success = await ref.read(obsidianSyncProvider.notifier).setCustomPath(path);
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? loc.tr('folderUpdated') : loc.tr('folderNotWritable')),
                      backgroundColor: success ? colors.success : colors.danger,
                    ),
                  );
                }
              }
            },
            child: Text(loc.tr('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final isArabic = currentLocale.languageCode == 'ar';
    final userName = ref.watch(userNameProvider);
    final uniEventsAsync = ref.watch(universityEventsStreamProvider);
    final eventCount = uniEventsAsync.asData?.value.length ?? 0;
    final themeState = ref.watch(themeProvider);
    final currentTheme = ref.watch(effectiveThemeProvider);
    final colors = currentTheme.colors;
    final presetName = themeState.preset.getName(isArabic);
    final obsidianState = ref.watch(obsidianSyncProvider);

    return AppBackground(
      slot: BackgroundSlot.settings,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(loc.tr('settings'), style: AppTypography.pageTitle),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
          children: [
            // 0. PROFILE
            Text(isArabic ? 'الملف الشخصي' : 'PROFILE', style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.user, size: 20, color: colors.secondary),
                          const SizedBox(width: 14),
                          Text(isArabic ? 'اسمك' : 'Your Name', style: AppTypography.cardTitle),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: InkWell(
                          onTap: () => _editUserName(userName),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 160),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    userName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.metadata.copyWith(color: colors.textPrimary),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(LucideIcons.pencil, size: 12, color: colors.textMuted),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: colors.border, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.flame, size: 20, color: colors.caloriesAccent),
                          const SizedBox(width: 14),
                          Text(loc.tr('dailyGoal'), style: AppTypography.cardTitle),
                        ],
                      ),
                      InkWell(
                        onTap: () => EditCalorieGoalSheet.show(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${ref.watch(calorieGoalProvider)} kcal',
                                style: AppTypography.metadata.copyWith(color: colors.textPrimary),
                              ),
                              const SizedBox(width: 6),
                              Icon(LucideIcons.pencil, size: 12, color: colors.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 1. APPEARANCE
            Text(loc.tr('appearance'), style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              onTap: () => context.push(AppRoutes.themeCenter),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(LucideIcons.palette, size: 20, color: colors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.tr('themeCenter'),
                                style: AppTypography.cardTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                loc.tr('themeCenterDesc'),
                                style: AppTypography.metadata.copyWith(color: colors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 130),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                presetName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.metadata.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isArabic ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                        size: 16,
                        color: colors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. LANGUAGE
            Text(loc.tr('language'), style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.languages, size: 20, color: colors.secondary),
                      const SizedBox(width: 14),
                      Text(loc.tr('languageTitle'), style: AppTypography.cardTitle),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: !isArabic ? colors.primary.withOpacity(0.28) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: !isArabic ? Border.all(color: colors.primary) : null,
                            ),
                            child: Text(
                              'English',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: !isArabic ? FontWeight.w700 : FontWeight.w500,
                                color: !isArabic ? colors.textPrimary : colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('ar')),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isArabic ? colors.primary.withOpacity(0.28) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isArabic ? Border.all(color: colors.primary) : null,
                            ),
                            child: Text(
                              'العربية',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isArabic ? FontWeight.w700 : FontWeight.w500,
                                color: isArabic ? colors.textPrimary : colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. UNIVERSITY TIMETABLE
            Text(loc.tr('universityTimetable'), style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.graduationCap, size: 20, color: colors.universityAccent),
                          const SizedBox(width: 14),
                          Text(loc.tr('timetableStatus'), style: AppTypography.cardTitle),
                        ],
                      ),
                      Text(
                        eventCount > 0
                            ? '$eventCount ${loc.tr('importedClasses')}'
                            : loc.tr('noTimetable'),
                        style: AppTypography.metadata.copyWith(
                          color: eventCount > 0 ? colors.secondary : colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GlassButton(
                          label: loc.tr('importTimetable'),
                          icon: LucideIcons.fileInput,
                          height: 40,
                          onPressed: () => context.push(AppRoutes.importTimetable),
                        ),
                      ),
                      if (eventCount > 0) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: GlassButton(
                            label: loc.tr('clear'),
                            icon: LucideIcons.trash2,
                            isDanger: true,
                            height: 40,
                            onPressed: () async {
                              final db = ref.read(databaseProvider);
                              await db.delete(db.universityEvents).go();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc.tr('clearTimetableDesc'))),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. OBSIDIAN DAILY NOTES
            Text(loc.tr('obsidianSync'), style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.notesAccent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.notesAccent.withOpacity(0.35)),
                        ),
                        child: Icon(LucideIcons.fileText, size: 22, color: colors.notesAccent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(loc.tr('obsidianSync'), style: AppTypography.cardTitle),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: obsidianState.isCustomPath
                                        ? colors.success.withOpacity(0.18)
                                        : colors.surfaceSecondary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: obsidianState.isCustomPath
                                          ? colors.success.withOpacity(0.4)
                                          : colors.border,
                                    ),
                                  ),
                                  child: Text(
                                    obsidianState.isCustomPath
                                        ? loc.tr('customFolderBadge')
                                        : loc.tr('defaultFolderBadge'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: obsidianState.isCustomPath
                                          ? colors.success
                                          : colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              loc.tr('obsidianSyncDesc'),
                              style: AppTypography.metadata.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Directory display
                  Text(
                    loc.tr('obsidianFolder'),
                    style: AppTypography.metadata.copyWith(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.folder, size: 16, color: colors.notesAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SelectableText(
                            obsidianState.vaultPath,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Folder control buttons
                  Row(
                    children: [
                      Expanded(
                        child: GlassButton(
                          label: loc.tr('changeFolder'),
                          icon: LucideIcons.folderOpen,
                          height: 38,
                          onPressed: () => ref.read(obsidianSyncProvider.notifier).pickFolder(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GlassButton(
                          label: loc.tr('enterPathManually'),
                          icon: LucideIcons.pencil,
                          isPrimary: false,
                          height: 38,
                          onPressed: () => _showManualPathDialog(obsidianState.vaultPath),
                        ),
                      ),
                      if (obsidianState.isCustomPath) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(LucideIcons.rotateCcw, size: 16, color: colors.textMuted),
                          tooltip: loc.tr('resetDefaultFolder'),
                          onPressed: () => ref.read(obsidianSyncProvider.notifier).resetToDefault(),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, color: colors.border),
                  const SizedBox(height: 12),

                  // Auto-sync toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.tr('autoSyncObsidian'), style: AppTypography.cardTitle.copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(
                              loc.tr('autoSyncObsidianDesc'),
                              style: AppTypography.metadata.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: obsidianState.autoSync,
                        activeColor: colors.notesAccent,
                        onChanged: (val) {
                          ref.read(obsidianSyncProvider.notifier).toggleAutoSync(val);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Divider(height: 1, color: colors.border),
                  const SizedBox(height: 14),

                  // Action buttons: Sync Today, Preview, Sync All
                  Row(
                    children: [
                      Expanded(
                        child: GlassButton(
                          label: loc.tr('syncNow'),
                          icon: LucideIcons.refreshCw,
                          height: 40,
                          onPressed: () async {
                            final success = await ref.read(obsidianSyncProvider.notifier).syncToday();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success ? loc.tr('todaySynced') : loc.tr('folderNotWritable')),
                                  backgroundColor: success ? colors.success : colors.danger,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GlassButton(
                          label: loc.tr('previewTodayMarkdown'),
                          icon: LucideIcons.eye,
                          isPrimary: false,
                          height: 40,
                          onPressed: () => ObsidianPreviewDialog.show(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GlassButton(
                    label: loc.tr('syncAllHistory'),
                    icon: LucideIcons.archive,
                    isPrimary: false,
                    height: 38,
                    onPressed: () async {
                      final count = await ref.read(obsidianSyncProvider.notifier).syncAllDays();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc.tr('syncedToObsidian', {'count': '$count'})),
                            backgroundColor: colors.success,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. DATA & BACKUP
            Text(loc.tr('dataAndBackup'), style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 18,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(LucideIcons.downloadCloud, color: colors.secondary),
                    title: Text(loc.tr('exportJson'), style: AppTypography.cardTitle),
                    subtitle: Text(loc.tr('exportJsonDesc'), style: AppTypography.metadata),
                    trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.textMuted),
                    onTap: _exportBackup,
                  ),
                  Divider(height: 1, color: colors.border),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(LucideIcons.uploadCloud, color: colors.info),
                    title: Text(loc.tr('importJson'), style: AppTypography.cardTitle),
                    subtitle: Text(loc.tr('importJsonDesc'), style: AppTypography.metadata),
                    trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.textMuted),
                    onTap: _showImportBackupSheet,
                  ),
                  Divider(height: 1, color: colors.border),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(LucideIcons.trash2, color: colors.danger),
                    title: Text(loc.tr('clearAllData'), style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
                    subtitle: Text(loc.tr('clearAllDataDesc'), style: AppTypography.metadata),
                    trailing: Icon(LucideIcons.chevronRight, size: 18, color: colors.textMuted),
                    onTap: _clearAllData,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. ABOUT
            Text(loc.tr('about'), style: AppTypography.labelUppercase),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colors.primary.withOpacity(0.18),
                          border: Border.all(
                            color: colors.primary.withOpacity(0.35),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            LucideIcons.sparkles,
                            size: 22,
                            color: colors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppConstants.appName, style: AppTypography.cardTitle),
                            const SizedBox(height: 2),
                            Text(
                              loc.tr('appTagline'),
                              style: AppTypography.metadata.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'v${AppConstants.appVersion}',
                        style: AppTypography.metadata.copyWith(
                          color: colors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: colors.border),
                  const SizedBox(height: 14),
                  // Twitter / X Button
                  InkWell(
                    onTap: _launchTwitter,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.textPrimary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '𝕏',
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              loc.tr('followOnX'),
                              style: AppTypography.cardTitle.copyWith(fontSize: 14),
                            ),
                          ),
                          Icon(LucideIcons.externalLink, size: 16, color: colors.textMuted),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
