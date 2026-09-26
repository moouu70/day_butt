import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/calorie_goal_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/animated_checkbox.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/section_header.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import '../../../services/ticker_provider.dart';
import '../../../services/timetable_service.dart';
import '../../../services/widget_sync_service.dart';
import '../../../services/obsidian_service.dart';
import '../../notes/presentation/add_note_sheet.dart';
import '../../todos/presentation/add_todo_sheet.dart';
import '../../university/data/timetable_parser.dart';
import 'widgets/home_metrics_row.dart';
import 'widgets/live_class_card.dart';
import 'widgets/obsidian_preview_dialog.dart';
import 'widgets/quick_actions_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final ValueChanged<int> onTabSelected;

  const HomeScreen({
    super.key,
    required this.onTabSelected,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  bool _showAllTasks = false;
  bool _showAllNotes = false;
  DateTime? _manualTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(obsidianSyncProvider.notifier).syncToday();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _manualTime = DateTime.now();
    });
    ref.invalidate(timeTickerProvider);
    ref.read(obsidianSyncProvider.notifier).syncToday();
    VibrationService.vibrateTick();
    await Future.delayed(const Duration(milliseconds: 250));
  }

  Future<void> _toggleTodoCompletion(Todo todo) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.todos)..where((t) => t.id.equals(todo.id))).write(
      TodosCompanion(
        completed: drift.Value(!todo.completed),
        completedAt: drift.Value(!todo.completed ? DateTime.now() : null),
      ),
    );
    ref.read(obsidianSyncProvider.notifier).syncToday();
  }

  Future<void> _deleteTodo(String id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.todos)..where((t) => t.id.equals(id))).go();
    ref.read(obsidianSyncProvider.notifier).syncToday();
  }

  Future<void> _deleteNote(String id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.notes)..where((t) => t.id.equals(id))).go();
    ref.read(obsidianSyncProvider.notifier).syncToday();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final loc = AppLocalizations.of(context);
    final userName = ref.watch(userNameProvider);
    final tickerTime = ref.watch(timeTickerProvider).value ?? DateTime.now();
    final now = _manualTime != null && _manualTime!.isAfter(tickerTime) ? _manualTime! : tickerTime;
    final greeting = AppDateUtils.getGreeting(time: now, isArabic: loc.isArabic);
    final dateStr = AppDateUtils.formatDate(now, locale: loc.locale.languageCode);

    // University events & state
    final uniEventsAsync = ref.watch(universityEventsStreamProvider);
    final allDbEvents = uniEventsAsync.value ?? [];
    final hasEvents = allDbEvents.isNotEmpty;

    final parsedEvents = allDbEvents.map((e) {
      return ParsedTimetableEvent(
        id: e.id,
        dayOfWeek: e.dayOfWeek,
        dayName: AppDateUtils.dayName(e.dayOfWeek, locale: loc.locale.languageCode),
        startTime: AppDateUtils.formatMinutes12Hour(e.startMinutes, locale: loc.locale.languageCode),
        endTime: AppDateUtils.formatMinutes12Hour(e.endMinutes, locale: loc.locale.languageCode),
        startMinutes: e.startMinutes,
        endMinutes: e.endMinutes,
        subject: e.subject,
        type: e.type,
        location: e.location,
        instructor: e.instructor,
      );
    }).toList();

    final timetableState = TimetableService.calculateState(
      allEvents: parsedEvents,
      now: now,
    );

    // Metrics
    final dailyRoutines = ref.watch(dailyRoutinesProvider);
    final totalRoutines = dailyRoutines.length;
    final completedRoutines = dailyRoutines.where((r) => r.isCompleted).length;

    final todayCalories = ref.watch(todayCaloriesSumStreamProvider);
    final todayExpenses = ref.watch(todayExpensesSumStreamProvider);
    final calorieGoal = ref.watch(calorieGoalProvider);

    // Keep native Android home screen widget synchronized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetSyncService.syncWidgetData(
        timetableEvents: parsedEvents,
        todayCalories: todayCalories,
        calorieGoal: calorieGoal,
        todayExpenses: todayExpenses,
        completedRoutines: completedRoutines,
        totalRoutines: totalRoutines,
      );
    });

    // Todos & Notes
    final todosAsync = ref.watch(todosStreamProvider);
    final notesAsync = ref.watch(notesStreamProvider);
    final todos = todosAsync.value ?? [];
    final notes = notesAsync.value ?? [];

    const int maxTodosPreview = 4;

    return AppBackground(
      slot: BackgroundSlot.home,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 76,
          title: GestureDetector(
            onTap: _refresh,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$greeting, $userName',
                  style: AppTypography.pageTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      dateStr,
                      style: AppTypography.metadata.copyWith(
                        color: colors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(LucideIcons.refreshCw, size: 10, color: colors.textMuted),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            // Circular glass refresh button
            Padding(
              padding: const EdgeInsets.only(right: 6, left: 6),
              child: GestureDetector(
                onTap: _refresh,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface.withOpacity(theme.glass.opacity.clamp(0.4, 0.95)),
                    border: Border.all(color: colors.border.withOpacity(theme.glass.borderOpacity.clamp(0.1, 0.4))),
                  ),
                  child: Center(
                    child: Icon(LucideIcons.refreshCw, size: 17, color: colors.textPrimary),
                  ),
                ),
              ),
            ),
            // Circular glass settings button
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 6),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.settings),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface.withOpacity(theme.glass.opacity.clamp(0.4, 0.95)),
                    border: Border.all(color: colors.border.withOpacity(theme.glass.borderOpacity.clamp(0.1, 0.4))),
                  ),
                  child: Center(
                    child: Icon(LucideIcons.settings, size: 18, color: colors.textPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: colors.primary,
          backgroundColor: colors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 130), // Generous bottom padding for radial nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Element: Current / Next University State
                LiveClassCard(
                  timetableState: timetableState,
                  hasEventsImported: hasEvents,
                  isLoading: uniEventsAsync.isLoading && !uniEventsAsync.hasValue,
                  onTap: () => widget.onTabSelected(1),
                ),

              const SizedBox(height: 20),

              // 2. Compact Today Summary (Secondary to the main card)
              HomeMetricsRow(
                completedRoutines: completedRoutines,
                totalRoutines: totalRoutines,
                todayCalories: todayCalories,
                todayExpenses: todayExpenses,
                onTabSelected: widget.onTabSelected,
                calorieGoal: calorieGoal,
              ),

              const SizedBox(height: 20),

              // 3. Quick Actions (Small circular shortcuts)
              const QuickActionsBar(),

              const SizedBox(height: 24),

              // 4. Today's Tasks Section
              SectionHeader(
                title: loc.tr('todaysTasks'),
                actionLabel: loc.tr('add'),
                onActionTap: () => AddTodoSheet.show(context),
                secondaryActionIcon: LucideIcons.fileText,
                secondaryActionTooltip: 'Obsidian Daily Note',
                onSecondaryActionTap: () => ObsidianPreviewDialog.show(context),
              ),
              if (todos.isEmpty)
                GestureDetector(
                  onTap: () {
                    VibrationService.vibrateTick();
                    AddTodoSheet.show(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: colors.surface.withOpacity(0.92),
                      border: Border.all(
                        color: colors.todoAccent.withOpacity(0.3),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.todoAccent.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: colors.todoAccent.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.todoAccent.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Icon(LucideIcons.checkSquare, size: 16, color: colors.todoAccent),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.tr('allCaughtUp'),
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                loc.isArabic ? 'اضغط لإضافة مهام ومواعيد لليوم' : 'Tap to add tasks & reminders for today',
                                style: TextStyle(
                                  color: colors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colors.todoAccent.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colors.todoAccent.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.plus, size: 12, color: colors.todoAccent),
                              const SizedBox(width: 4),
                              Text(
                                loc.tr('todo'),
                                style: TextStyle(
                                  color: colors.todoAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (_showAllTasks ? todos : todos.take(maxTodosPreview).toList()).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final displayedList = _showAllTasks ? todos : todos.take(maxTodosPreview).toList();
                    final todo = displayedList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: colors.surfaceSecondary.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colors.border.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          AnimatedCheckbox(
                            value: todo.completed,
                            onChanged: (_) {
                              VibrationService.vibrateTick();
                              _toggleTodoCompletion(todo);
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                VibrationService.vibrateTick();
                                AddTodoSheet.show(context, todo: todo);
                              },
                              child: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: todo.completed ? TextDecoration.lineThrough : null,
                                  color: todo.completed ? colors.textMuted : colors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(LucideIcons.trash2, size: 14, color: colors.textMuted),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            onPressed: () {
                              VibrationService.vibrateTick();
                              _deleteTodo(todo.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (todos.length > maxTodosPreview)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          VibrationService.vibrateTick();
                          setState(() => _showAllTasks = !_showAllTasks);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _showAllTasks
                                    ? loc.tr('showLess')
                                    : loc.tr('moreTasks', {'count': '${todos.length - maxTodosPreview}'}),
                                style: AppTypography.metadata.copyWith(
                                  color: colors.todoAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _showAllTasks ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                                size: 14,
                                color: colors.todoAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 24),

              // 5. Quick Note Section
              SectionHeader(
                title: loc.tr('quickNote'),
                actionLabel: loc.tr('add'),
                onActionTap: () => AddNoteSheet.show(context),
                secondaryActionIcon: LucideIcons.fileText,
                secondaryActionTooltip: 'Obsidian Daily Note',
                onSecondaryActionTap: () => ObsidianPreviewDialog.show(context),
              ),
              if (notes.isEmpty)
                GestureDetector(
                  onTap: () {
                    VibrationService.vibrateTick();
                    AddNoteSheet.show(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: colors.surface.withOpacity(0.92),
                      border: Border.all(
                        color: colors.notesAccent.withOpacity(0.3),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.notesAccent.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: colors.notesAccent.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.notesAccent.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Icon(LucideIcons.fileText, size: 16, color: colors.notesAccent),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            loc.tr('captureThought'),
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.notesAccent.withOpacity(0.14),
                            border: Border.all(
                              color: colors.notesAccent.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(LucideIcons.plus, size: 15, color: colors.notesAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Builder(
                  builder: (context) {
                    const int maxNotesPreview = 4;
                    final displayedNotes = _showAllNotes ? notes : notes.take(maxNotesPreview).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.15,
                          ),
                          itemCount: displayedNotes.length,
                          itemBuilder: (context, index) {
                            final note = displayedNotes[index];
                            return GestureDetector(
                              onTap: () {
                                VibrationService.vibrateTick();
                                AddNoteSheet.show(context, note: note);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: colors.surfaceSecondary.withOpacity(0.85),
                                  border: Border.all(
                                    color: colors.notesAccent.withOpacity(0.26),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors.notesAccent.withOpacity(0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: colors.notesAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            AppDateUtils.formatTime12Hour(note.createdAt, locale: loc.locale.languageCode),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.metadata.copyWith(
                                              fontSize: 10,
                                              color: colors.textMuted,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(LucideIcons.trash2, size: 13, color: colors.textMuted),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                                          onPressed: () {
                                            VibrationService.vibrateTick();
                                            _deleteNote(note.id);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: Text(
                                        note.content,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.body.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 1.35,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        if (notes.length > maxNotesPreview)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  VibrationService.vibrateTick();
                                  setState(() => _showAllNotes = !_showAllNotes);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _showAllNotes
                                            ? loc.tr('showLess')
                                            : loc.tr('moreNotes', {'count': '${notes.length - maxNotesPreview}'}),
                                        style: AppTypography.metadata.copyWith(
                                          color: colors.notesAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        _showAllNotes ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                                        size: 14,
                                        color: colors.notesAccent,
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
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
  }
}
