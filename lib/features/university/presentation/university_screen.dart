import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/models/theme_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/models/background_slot.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_background.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import '../../../services/ticker_provider.dart';
import '../data/timetable_parser.dart';

class UniversityScreen extends ConsumerStatefulWidget {
  const UniversityScreen({super.key});

  @override
  ConsumerState<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends ConsumerState<UniversityScreen> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
  }

  void _selectToday() {
    setState(() {
      _selectedDay = DateTime.now().weekday;
    });
  }

  void _copyJsonToClipboard(String jsonText, String successMsg) {
    VibrationService.vibratePress();
    Clipboard.setData(ClipboardData(text: jsonText));
    final colors = ref.read(effectiveThemeProvider).colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(LucideIcons.checkCheck, color: colors.universityAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(successMsg)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.surface,
      ),
    );
  }

  void _showCopyOptionsSheet(BuildContext context, AppLocalizations loc, List<UniversityEvent> events) {
    VibrationService.vibratePress();
    if (events.isEmpty) {
      _copyJsonToClipboard(TimetableParser.sampleJson, loc.tr('jsonCopied'));
      return;
    }

    final colors = ref.read(effectiveThemeProvider).colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: colors.border),
            left: BorderSide(color: colors.border),
            right: BorderSide(color: colors.border),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.textMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              loc.tr('copyJsonFormat'),
              style: AppTypography.sectionTitle.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: colors.border),
              ),
              tileColor: colors.surface.withOpacity(0.5),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.universityAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.code, color: colors.universityAccent, size: 18),
              ),
              title: Text(loc.tr('copyJsonTemplate'), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                loc.isArabic ? 'النموذج الافتراضي للجدول مع أمثلة للمحاضرات' : 'Default sample schema with lecture examples',
                style: TextStyle(fontSize: 11, color: colors.textMuted),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _copyJsonToClipboard(TimetableParser.sampleJson, loc.tr('jsonCopied'));
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: colors.border),
              ),
              tileColor: colors.surface.withOpacity(0.5),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.universityAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.graduationCap, color: colors.universityAccent, size: 18),
              ),
              title: Text(loc.tr('copyCurrentTimetable'), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                loc.isArabic
                    ? 'تصدير جدولك المسجل حالياً (${events.length} محاضرة) بصيغة JSON'
                    : 'Export your loaded classes (${events.length} classes) as JSON',
                style: TextStyle(fontSize: 11, color: colors.textMuted),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                final exported = TimetableParser.exportEventsToJson(events);
                _copyJsonToClipboard(exported, loc.tr('myTimetableJsonCopied'));
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final localeStr = loc.locale.languageCode;
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;
    final eventsAsync = ref.watch(universityEventsStreamProvider);
    final now = ref.watch(timeTickerProvider).value ?? DateTime.now();
    final todayWeekday = now.weekday;
    final currentMinutes = (now.hour * 60) + now.minute;

    // Pre-compute date info for AppBar title
    final mondayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final selectedDateForTitle = mondayOfWeek.add(Duration(days: _selectedDay - 1));
    final isTodayForTitle = _selectedDay == todayWeekday;

    String titleDateFormatted;
    try {
      titleDateFormatted = DateFormat('MMMM d, yyyy', localeStr).format(selectedDateForTitle);
    } catch (_) {
      titleDateFormatted = DateFormat('MMMM d, yyyy').format(selectedDateForTitle);
    }

    final titleDayName = isTodayForTitle
        ? loc.tr('today')
        : AppDateUtils.dayName(_selectedDay, locale: localeStr);

    return AppBackground(
      slot: BackgroundSlot.university,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 68,
          titleSpacing: 20,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titleDateFormatted,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                titleDayName,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          actions: [
            if (_selectedDay != todayWeekday)
              TextButton(
                onPressed: _selectToday,
                child: Text(
                  loc.tr('today'),
                  style: TextStyle(
                    color: colors.universityAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(LucideIcons.copy, size: 20),
              tooltip: loc.tr('copyJsonFormat'),
              onPressed: () {
                final events = eventsAsync.asData?.value ?? [];
                _showCopyOptionsSheet(context, loc, events);
              },
            ),
            IconButton(
              icon: const Icon(LucideIcons.fileInput, size: 20),
              tooltip: loc.tr('importTimetable'),
              onPressed: () => context.push(AppRoutes.importTimetable),
            ),
          ],
        ),
        body: eventsAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: colors.universityAccent)),
          error: (err, _) => Center(child: Text('Error: $err', style: AppTypography.bodyMuted)),
          data: (allEvents) {
            if (allEvents.isEmpty) {
              return _EmptyTimetableGuide(
                colors: colors,
                onNavigateToImport: () => context.push(AppRoutes.importTimetable),
              );
            }

            // Filter events for selected day
            final dayEvents = allEvents.where((e) => e.dayOfWeek == _selectedDay).toList()
              ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 2. HORIZONTAL 7-DAY STRIP (Mon 4, Tue 5, etc.)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: colors.surface.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final dayNumber = index + 1; // 1 = Monday
                      final dayDate = mondayOfWeek.add(Duration(days: index));
                      final isSelected = dayNumber == _selectedDay;
                      final isCurrentDay = dayNumber == todayWeekday;

                      return GestureDetector(
                        onTap: () {
                          VibrationService.vibrateTab();
                          setState(() => _selectedDay = dayNumber);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppDateUtils.shortDayName(dayNumber, locale: localeStr),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? colors.universityAccent
                                      : colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${dayDate.day}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected
                                      ? colors.universityAccent
                                      : isCurrentDay
                                          ? colors.textPrimary
                                          : colors.textSecondary.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? colors.universityAccent : Colors.transparent,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: colors.universityAccent.withOpacity(0.6),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 18),

                // 3. VERTICAL TIMELINE LIST OR EMPTY STATE
                Expanded(
                  child: dayEvents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.surface.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: colors.border.withOpacity(0.2)),
                                ),
                                child: Icon(
                                  LucideIcons.calendarCheck,
                                  size: 32,
                                  color: colors.universityAccent.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loc.tr('noClassesOnDay'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                loc.tr('noClassesScheduledDesc'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 130), // Clears radial nav
                          itemCount: dayEvents.length,
                          itemBuilder: (context, index) {
                            final event = dayEvents[index];
                            final isToday = _selectedDay == todayWeekday;
                            final isCurrentlyIn = isToday &&
                                currentMinutes >= event.startMinutes &&
                                currentMinutes < event.endMinutes;
                            final isPast = isToday && currentMinutes >= event.endMinutes;

                            return _TimelineClassItem(
                              event: event,
                              isCurrentlyIn: isCurrentlyIn,
                              isPast: isPast,
                              isFirst: index == 0,
                              isLast: index == dayEvents.length - 1,
                              localeStr: localeStr,
                              colors: colors,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TimelineClassItem extends StatelessWidget {
  final UniversityEvent event;
  final bool isCurrentlyIn;
  final bool isPast;
  final bool isFirst;
  final bool isLast;
  final String localeStr;
  final ThemeColors colors;

  const _TimelineClassItem({
    required this.event,
    required this.isCurrentlyIn,
    required this.isPast,
    required this.isFirst,
    required this.isLast,
    required this.localeStr,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final startTimeStr = AppDateUtils.formatMinutes12Hour(event.startMinutes, locale: localeStr);
    final endTimeStr = AppDateUtils.formatMinutes12Hour(event.endMinutes, locale: localeStr);
    final timeStr = '$startTimeStr — $endTimeStr';
    final lineColor = colors.border.withOpacity(0.35);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Node & Line Column
          SizedBox(
            width: 28,
            child: Column(
              children: [
                // Top line segment
                Container(
                  width: 2,
                  height: 22,
                  color: isFirst ? Colors.transparent : lineColor,
                ),
                // Timeline Node
                if (isCurrentlyIn)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.universityAccent.withOpacity(0.2),
                      border: Border.all(color: colors.universityAccent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: colors.universityAccent.withOpacity(0.45),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.universityAccent,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.backgroundDeep,
                      border: Border.all(
                        color: isPast
                            ? colors.textMuted.withOpacity(0.4)
                            : colors.universityAccent.withOpacity(0.65),
                        width: 2.2,
                      ),
                    ),
                  ),
                // Bottom line segment
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : lineColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Event Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: isCurrentlyIn
                  ? _buildActiveCard(timeStr)
                  : _buildRegularCard(timeStr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCard(String timeStr) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.universityAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.universityAccent.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title & Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.subject,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Subtitle / Location & Instructor
          if (event.location != null || event.instructor != null) ...[
            Text(
              [
                if (event.location != null && event.location!.isNotEmpty) event.location!,
                if (event.instructor != null && event.instructor!.isNotEmpty) event.instructor!,
              ].join(' • '),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.88),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Bottom status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'CURRENTLY IN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularCard(String timeStr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.68),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title & Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isPast ? colors.textMuted : colors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Subtitle
          if (event.location != null || event.instructor != null)
            Text(
              [
                if (event.location != null && event.location!.isNotEmpty) event.location!,
                if (event.instructor != null && event.instructor!.isNotEmpty) event.instructor!,
              ].join(' • '),
              style: TextStyle(
                fontSize: 13,
                color: colors.textMuted,
                height: 1.3,
              ),
            ),

          if (event.type.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                event.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.universityAccent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Inline guide shown when no timetable is imported ────────────────────────
class _EmptyTimetableGuide extends StatefulWidget {
  final dynamic colors;
  final VoidCallback onNavigateToImport;
  const _EmptyTimetableGuide({
    required this.colors,
    required this.onNavigateToImport,
  });

  @override
  State<_EmptyTimetableGuide> createState() => _EmptyTimetableGuideState();
}

class _EmptyTimetableGuideState extends State<_EmptyTimetableGuide> {
  bool _promptCopied = false;

  static const _aiPrompt =
      'You are a university timetable assistant. Convert the timetable I will describe '
      'into a structured JSON response using ONLY this exact format — no extra text, no markdown, just the raw JSON:\n\n'
      '{\n'
      '  "type": "timetable",\n'
      '  "version": 1,\n'
      '  "timezone": "Africa/Cairo",\n'
      '  "university": {\n'
      '    "name": "YOUR_FACULTY_NAME",\n'
      '    "group": "YOUR_GROUP"\n'
      '  },\n'
      '  "events": [\n'
      '    {\n'
      '      "day": "Monday",\n'
      '      "start": "08:30",\n'
      '      "end": "10:30",\n'
      '      "subject": "Subject Name",\n'
      '      "type": "Lecture",\n'
      '      "location": "Room A1",\n'
      '      "instructor": "Dr. Name"\n'
      '    }\n'
      '  ]\n'
      '}\n\n'
      'Rules:\n'
      '- "day" must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday\n'
      '- "start" and "end" must be in HH:mm 24-hour format (e.g. 08:30, 14:00)\n'
      '- "type" can be: Lecture, Lab, Tutorial, Seminar, or any class type\n'
      '- "location" and "instructor" are optional\n'
      '- Output ONLY the JSON — nothing else\n\n'
      'Here is my timetable:\n'
      '[PASTE YOUR TIMETABLE HERE]';

  void _copyPrompt() {
    Clipboard.setData(const ClipboardData(text: _aiPrompt));
    setState(() => _promptCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(LucideIcons.checkCheck,
                color: widget.colors.universityAccent, size: 18),
            const SizedBox(width: 8),
            const Expanded(child: Text('Prompt copied! Paste it into any AI chat.')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: widget.colors.surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  c.universityAccent.withOpacity(0.18),
                  c.universityAccent.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: c.universityAccent.withOpacity(0.25)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: c.universityAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: c.universityAccent.withOpacity(0.3)),
                  ),
                  child: Icon(LucideIcons.bot, color: c.universityAccent, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'No timetable yet — import with AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Copy the prompt, share your timetable with any AI (ChatGPT, Gemini, Claude…), then paste the JSON response back.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: c.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // How it works card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.surface.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.border.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOW IT WORKS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.textMuted, letterSpacing: 1.2),
                ),
                const SizedBox(height: 14),
                _step(c, LucideIcons.copy, 'Copy the AI prompt',
                    'Tap "Copy AI Prompt" — it tells the AI exactly what format to return.'),
                const SizedBox(height: 14),
                _step(c, LucideIcons.messageSquare, 'Share your timetable with the AI',
                    'Open ChatGPT, Gemini, or Claude. Paste the prompt, then describe your schedule.'),
                const SizedBox(height: 14),
                _step(c, LucideIcons.clipboardPaste, 'Paste the JSON back',
                    'Come back here, tap Import, paste the response — done!'),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Copy AI Prompt button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _promptCopied
                    ? [c.success.withOpacity(0.25), c.success.withOpacity(0.1)]
                    : [c.universityAccent.withOpacity(0.28), c.universityAccent.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _promptCopied ? c.success.withOpacity(0.5) : c.universityAccent.withOpacity(0.45),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _copyPrompt,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _promptCopied ? LucideIcons.checkCheck : LucideIcons.copy,
                        size: 20,
                        color: _promptCopied ? c.success : c.universityAccent,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _promptCopied ? 'Prompt Copied!' : 'Copy AI Prompt',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _promptCopied ? c.success : c.universityAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Go to import button
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: widget.onNavigateToImport,
              icon: const Icon(LucideIcons.fileInput, size: 18),
              label: const Text('Go to Import', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.universityAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(dynamic c, IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: c.universityAccent.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: c.universityAccent.withOpacity(0.3)),
          ),
          child: Center(child: Icon(icon, size: 15, color: c.universityAccent)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: c.textPrimary)),
              const SizedBox(height: 3),
              Text(desc, style: TextStyle(fontSize: 12, color: c.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
