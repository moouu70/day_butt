import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/animated_checkbox.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import 'add_routine_sheet.dart';



class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  Future<void> _toggleCompletion({
    required WidgetRef ref,
    required Routine routine,
    required bool isCompleted,
    required String? completionId,
  }) async {
    final db = ref.read(databaseProvider);
    final todayKey = AppDateUtils.toDateKey(DateTime.now());

    if (isCompleted && completionId != null) {
      // Uncheck
      await (db.delete(db.routineCompletions)
            ..where((t) => t.id.equals(completionId)))
          .go();
    } else {
      // Check
      await db.into(db.routineCompletions).insert(
        RoutineCompletionsCompanion.insert(
          id: const Uuid().v4(),
          routineId: routine.id,
          date: todayKey,
          completed: const drift.Value(true),
          completedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _reorderRoutines({
    required WidgetRef ref,
    required List<DailyRoutineItem> currentList,
    required int oldIndex,
    required int newIndex,
  }) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final items = List<DailyRoutineItem>.from(currentList);
    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);

    VibrationService.vibrateTick();
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      for (int i = 0; i < items.length; i++) {
        await (db.update(db.routines)..where((t) => t.id.equals(items[i].routine.id))).write(
          RoutinesCompanion(sortOrder: drift.Value(i)),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final dailyRoutines = ref.watch(dailyRoutinesProvider);
    final totalCount = dailyRoutines.length;
    final completedCount = dailyRoutines.where((r) => r.isCompleted).length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return AppBackground(
      slot: BackgroundSlot.routine,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(loc.tr('routines'), style: AppTypography.pageTitle),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.plus, size: 20),
              tooltip: loc.tr('createRoutine'),
              onPressed: () => AddRoutineSheet.show(context),
            ),
          ],
        ),
        body: dailyRoutines.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                child: Column(
                  children: [
                    EmptyState(
                      icon: LucideIcons.checkCircle2,
                      title: loc.tr('noRoutinesYet'),
                      subtitle: loc.tr('noRoutinesDesc'),
                      buttonLabel: loc.tr('createRoutine'),
                      onButtonPressed: () => AddRoutineSheet.show(context),
                     ),
                   ],
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Routine Progress Banner
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 22,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                loc.tr('todaysProgress'),
                                style: AppTypography.labelUppercase.copyWith(
                                  letterSpacing: 1.5,
                                  color: colors.routineAccent,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: completedCount == totalCount && totalCount > 0
                                      ? colors.success.withOpacity(0.15)
                                      : colors.routineAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  completedCount == totalCount && totalCount > 0
                                      ? loc.tr('allDone')
                                      : loc.tr('active'),
                                  style: AppTypography.badge.copyWith(
                                    color: completedCount == totalCount && totalCount > 0
                                        ? colors.success
                                        : colors.routineAccent,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$completedCount',
                                style: AppTypography.dashboardNumber.copyWith(
                                  fontSize: 36,
                                  color: completedCount == totalCount && totalCount > 0
                                      ? colors.success
                                      : colors.textPrimary,
                                ),
                              ),
                              Text(
                                ' / $totalCount ${loc.tr('completed')}',
                                style: AppTypography.cardSubtitle.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: colors.surfaceSecondary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                completedCount == totalCount && totalCount > 0
                                    ? colors.success
                                    : colors.routineAccent,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Routine Checklist Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.tr('dailyChecklist'), style: AppTypography.sectionTitle),
                            if (dailyRoutines.length > 1)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  loc.tr('dragToReorder'),
                                  style: AppTypography.metadata.copyWith(fontSize: 11, color: colors.textMuted),
                                ),
                              ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => AddRoutineSheet.show(context),
                          icon: Icon(LucideIcons.plus, size: 15, color: colors.routineAccent),
                          label: Text(
                            loc.tr('newRoutine'),
                            style: TextStyle(color: colors.routineAccent, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Routine Items with Reordering
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: dailyRoutines.length,
                      onReorder: (oldIdx, newIdx) => _reorderRoutines(
                        ref: ref,
                        currentList: dailyRoutines,
                        oldIndex: oldIdx,
                        newIndex: newIdx,
                      ),
                      itemBuilder: (context, index) {
                        final item = dailyRoutines[index];
                        final routine = item.routine;
                        final isCompleted = item.isCompleted;

                        return Padding(
                          key: ValueKey('routine_${routine.id}'),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Dismissible(
                            key: Key('dismiss_${routine.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: colors.danger.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(LucideIcons.trash2, color: colors.danger),
                            ),
                            onDismissed: (_) {
                              final db = ref.read(databaseProvider);
                              (db.delete(db.routines)..where((t) => t.id.equals(routine.id))).go();
                              (db.delete(db.routineCompletions)..where((t) => t.routineId.equals(routine.id))).go();
                            },
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              borderRadius: 16,
                              child: Row(
                              children: [
                                  AnimatedCheckbox(
                                    value: isCompleted,
                                    activeColor: colors.success,
                                    onChanged: (_) => _toggleCompletion(
                                      ref: ref,
                                      routine: routine,
                                      isCompleted: isCompleted,
                                      completionId: item.completionId,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          routine.name,
                                          style: AppTypography.cardTitle.copyWith(
                                            color: isCompleted ? colors.textMuted : colors.textPrimary,
                                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        if (routine.preferredTime != null && routine.preferredTime!.isNotEmpty) ...[
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Icon(LucideIcons.clock, size: 12, color: colors.textMuted),
                                              const SizedBox(width: 4),
                                              Text(routine.preferredTime!, style: AppTypography.metadata),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 8, end: 4, top: 4, bottom: 4),
                                      child: Icon(
                                        LucideIcons.gripVertical,
                                        size: 18,
                                        color: colors.textMuted.withOpacity(0.55),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}

