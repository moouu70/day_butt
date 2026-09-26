import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as p;
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../database/database_provider.dart';
import '../../../../services/obsidian_service.dart';

class ObsidianPreviewDialog extends ConsumerStatefulWidget {
  const ObsidianPreviewDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => const ObsidianPreviewDialog(),
    );
  }

  @override
  ConsumerState<ObsidianPreviewDialog> createState() => _ObsidianPreviewDialogState();
}

class _ObsidianPreviewDialogState extends ConsumerState<ObsidianPreviewDialog> {
  String? _markdownContent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final content = await ObsidianService.getTodayPreviewContent(db);
    if (mounted) {
      setState(() {
        _markdownContent = content;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final obsidianState = ref.watch(obsidianSyncProvider);
    final targetFileName = ObsidianService.getDailyFileName(DateTime.now());
    final folderBasename = p.basename(obsidianState.vaultPath);

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.notesAccent.withOpacity(0.4)),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.notesAccent.withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(LucideIcons.fileText, size: 18, color: colors.notesAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.tr('obsidianMarkdownPreview'),
                  style: AppTypography.cardTitle.copyWith(fontSize: 16),
                ),
                Text(
                  '$folderBasename/$targetFileName',
                  style: AppTypography.metadata.copyWith(fontSize: 11, color: colors.notesAccent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Folder status & Change path
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.folder, size: 14, color: colors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      obsidianState.vaultPath,
                      style: AppTypography.metadata.copyWith(fontSize: 10, color: colors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () async {
                      await ref.read(obsidianSyncProvider.notifier).pickFolder();
                      _loadPreview();
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      child: Text(
                        loc.tr('changeFolder'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Markdown preview container
            Container(
              height: 250,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.background.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: SelectableText(
                        _markdownContent ?? '',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11.5,
                          height: 1.45,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 10),

            // Auto-sync status text
            Row(
              children: [
                Icon(
                  obsidianState.autoSync ? LucideIcons.checkCircle2 : LucideIcons.alertCircle,
                  size: 13,
                  color: obsidianState.autoSync ? colors.success : colors.warning,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    obsidianState.autoSync ? loc.tr('autoSyncObsidianDesc') : 'Auto-sync is disabled in settings',
                    style: AppTypography.metadata.copyWith(fontSize: 10, color: colors.textMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.tr('cancel'), style: TextStyle(color: colors.textSecondary)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.notesAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(LucideIcons.copy, size: 14),
          label: Text(loc.tr('copyMarkdown'), style: const TextStyle(fontSize: 12)),
          onPressed: () {
            if (_markdownContent != null) {
              Clipboard.setData(ClipboardData(text: _markdownContent!));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.tr('markdownCopied')),
                  backgroundColor: colors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
