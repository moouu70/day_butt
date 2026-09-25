import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/providers/theme_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../services/timetable_service.dart';

class LiveClassCard extends ConsumerWidget {
  final TimetableState timetableState;
  final bool hasEventsImported;
  final bool isLoading;
  final VoidCallback? onTap;

  const LiveClassCard({
    super.key,
    required this.timetableState,
    required this.hasEventsImported,
    this.isLoading = false,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else {
      context.push(AppRoutes.university);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final loc = AppLocalizations.of(context);
    final localeStr = loc.locale.languageCode;

    if (isLoading && !hasEventsImported) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        borderRadius: 22,
        borderColor: colors.border.withOpacity(0.15),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 130,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 190,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (!hasEventsImported) {
      return GlassCard(
        onTap: () => context.push(AppRoutes.importTimetable),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        borderRadius: 22,
        borderColor: colors.border.withOpacity(0.2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.universityAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(LucideIcons.graduationCap, size: 22, color: colors.universityAccent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.tr('noTimetableImported'),
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 15,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    loc.tr('noTimetableImportedDesc'),
                    style: AppTypography.metadata.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 18, color: colors.textMuted),
          ],
        ),
      );
    }

    switch (timetableState.status) {
      case TimetableStatus.inClass:
        final current = timetableState.currentClass!;
        final startStr = AppDateUtils.formatMinutes12Hour(current.startMinutes, locale: localeStr);
        final endStr = AppDateUtils.formatMinutes12Hour(current.endMinutes, locale: localeStr);
        final remainingStr = AppDateUtils.formatRemainingTime(timetableState.remainingMinutes, isArabic: loc.isArabic);

        return GlassCard(
          padding: const EdgeInsets.all(22),
          borderRadius: 22,
          borderColor: colors.universityAccent.withOpacity(0.55),
          borderWidth: 1.5,
          glow: BoxShadow(
            color: colors.universityAccent.withOpacity(0.24),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
          onTap: () => _handleTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.universityAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc.tr('currentlyIn'),
                        style: AppTypography.labelUppercase.copyWith(
                          color: colors.universityAccent,
                          letterSpacing: 1.5,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.universityAccent.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.universityAccent.withOpacity(0.35)),
                    ),
                    child: Text(
                      current.type,
                      style: AppTypography.metadata.copyWith(
                        color: colors.universityAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                current.subject,
                style: AppTypography.pageTitle.copyWith(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              if (current.location != null && current.location!.isNotEmpty) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 14, color: colors.textSecondary),
                    const SizedBox(width: 5),
                    Text(
                      current.location!,
                      style: AppTypography.cardSubtitle.copyWith(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$startStr — $endStr',
                    style: AppTypography.metadata.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(timetableState.progress * 100).toInt()}%',
                    style: AppTypography.metadata.copyWith(
                      color: colors.universityAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: timetableState.progress.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: colors.surfaceSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.universityAccent),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(LucideIcons.clock, size: 13, color: colors.universityAccent),
                  const SizedBox(width: 5),
                  Text(
                    remainingStr,
                    style: AppTypography.metadata.copyWith(
                      color: colors.universityAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case TimetableStatus.beforeNextClass:
        final next = timetableState.nextClass!;
        final startStr = AppDateUtils.formatMinutes12Hour(next.startMinutes, locale: localeStr);
        final endStr = AppDateUtils.formatMinutes12Hour(next.endMinutes, locale: localeStr);
        final untilStr = AppDateUtils.formatStartsIn(timetableState.minutesUntilNext, isArabic: loc.isArabic);

        return GlassCard(
          padding: const EdgeInsets.all(22),
          borderRadius: 22,
          borderColor: colors.universityAccent.withOpacity(0.4),
          borderWidth: 1.5,
          onTap: () => _handleTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.tr('nextClass'),
                    style: AppTypography.labelUppercase.copyWith(
                      color: colors.universityAccent,
                      letterSpacing: 1.5,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.universityAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.universityAccent.withOpacity(0.35)),
                    ),
                    child: Text(
                      untilStr,
                      style: AppTypography.metadata.copyWith(
                        color: colors.universityAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                next.subject,
                style: AppTypography.pageTitle.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${next.type}${next.location != null && next.location!.isNotEmpty ? " · ${next.location}" : ""}',
                style: AppTypography.cardSubtitle.copyWith(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(LucideIcons.clock, size: 14, color: colors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    '$startStr — $endStr',
                    style: AppTypography.metadata.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case TimetableStatus.noMoreClassesToday:
        final next = timetableState.nextClass;
        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          borderRadius: 22,
          onTap: () => _handleTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(LucideIcons.checkCheck, size: 20, color: colors.success),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.tr('allClassesCompleted'),
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 15,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loc.tr('allClassesCompletedDesc'),
                          style: AppTypography.metadata.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (next != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.surfaceSecondary.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.calendar, size: 14, color: colors.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${loc.tr('nextClass')}: ${next.subject} (${timetableState.daysUntilNext == 1 ? loc.tr('tomorrow') : AppDateUtils.dayName(next.dayOfWeek, locale: localeStr)} ${AppDateUtils.formatMinutes12Hour(next.startMinutes, locale: localeStr)})',
                          style: AppTypography.metadata.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );

      case TimetableStatus.noClassesToday:
        final next = timetableState.nextClass;
        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          borderRadius: 22,
          onTap: () => _handleTap(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(LucideIcons.calendarOff, size: 20, color: colors.textSecondary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.tr('noClassesScheduled'),
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 15,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loc.tr('noClassesScheduledDesc'),
                          style: AppTypography.metadata.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (next != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.universityAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.universityAccent.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.calendar, size: 14, color: colors.universityAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${loc.tr('nextClass')}: ${next.subject} (${timetableState.daysUntilNext == 1 ? loc.tr('tomorrow') : AppDateUtils.dayName(next.dayOfWeek, locale: localeStr)} ${AppDateUtils.formatMinutes12Hour(next.startMinutes, locale: localeStr)})',
                          style: AppTypography.metadata.copyWith(
                            color: colors.universityAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
    }
  }
}
