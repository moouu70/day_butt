import '../features/university/data/timetable_parser.dart';

enum TimetableStatus {
  inClass,
  beforeNextClass,
  noMoreClassesToday,
  noClassesToday,
}

class TimetableState {
  final TimetableStatus status;
  final ParsedTimetableEvent? currentClass;
  final ParsedTimetableEvent? nextClass;
  final int daysUntilNext; // 0 for today, 1 for tomorrow, etc.
  final List<ParsedTimetableEvent> todayClasses;
  final double progress; // 0.0 to 1.0
  final int remainingMinutes; // in current class
  final int minutesUntilNext; // until next class starts
  final String statusDescription;

  const TimetableState({
    required this.status,
    this.currentClass,
    this.nextClass,
    this.daysUntilNext = 0,
    required this.todayClasses,
    this.progress = 0.0,
    this.remainingMinutes = 0,
    this.minutesUntilNext = 0,
    required this.statusDescription,
  });

  String get remainingTimeString {
    if (remainingMinutes <= 0) return '0m remaining';
    final h = remainingMinutes ~/ 60;
    final m = remainingMinutes % 60;
    if (h > 0) {
      return '${h}h ${m}m remaining';
    }
    return '${m}m remaining';
  }

  String get untilNextString {
    if (minutesUntilNext <= 0) return 'Starting now';
    final h = minutesUntilNext ~/ 60;
    final m = minutesUntilNext % 60;
    if (h > 0) {
      return '${h}h ${m}m';
    }
    return '$m minutes';
  }
}

class TimetableService {
  /// Computes the current timetable state given all timetable events and current time
  static TimetableState calculateState({
    required List<ParsedTimetableEvent> allEvents,
    required DateTime now,
  }) {
    final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
    final currentMinutes = (now.hour * 60) + now.minute;

    // Filter and sort today's classes by start time
    final todayClasses = allEvents
        .where((e) => e.dayOfWeek == currentDay)
        .toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

    // Look ahead across the next 7 days for the next upcoming class (tomorrow, etc.)
    ParsedTimetableEvent? upcomingClassInWeek;
    int daysUntilUpcoming = 0;

    for (int offset = 1; offset <= 7; offset++) {
      final checkDay = ((currentDay - 1 + offset) % 7) + 1;
      final dayClasses = allEvents
          .where((e) => e.dayOfWeek == checkDay)
          .toList()
        ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
      if (dayClasses.isNotEmpty) {
        upcomingClassInWeek = dayClasses.first;
        daysUntilUpcoming = offset;
        break;
      }
    }

    if (todayClasses.isEmpty) {
      return TimetableState(
        status: TimetableStatus.noClassesToday,
        todayClasses: const [],
        nextClass: upcomingClassInWeek,
        daysUntilNext: daysUntilUpcoming,
        statusDescription: 'No university classes today',
      );
    }

    // Check if currently inside a class
    for (final event in todayClasses) {
      if (currentMinutes >= event.startMinutes && currentMinutes < event.endMinutes) {
        final totalDuration = event.endMinutes - event.startMinutes;
        final elapsed = currentMinutes - event.startMinutes;
        final remaining = event.endMinutes - currentMinutes;
        final progress = totalDuration > 0
            ? (elapsed / totalDuration).clamp(0.0, 1.0)
            : 0.0;

        // Also check if there is a next class after this one
        final nextClasses = todayClasses
            .where((e) => e.startMinutes >= event.endMinutes)
            .toList();
        final nextClass = nextClasses.isNotEmpty
            ? nextClasses.first
            : upcomingClassInWeek;
        final daysUntil = nextClasses.isNotEmpty ? 0 : daysUntilUpcoming;

        return TimetableState(
          status: TimetableStatus.inClass,
          currentClass: event,
          nextClass: nextClass,
          daysUntilNext: daysUntil,
          todayClasses: todayClasses,
          progress: progress,
          remainingMinutes: remaining,
          statusDescription: 'Currently in ${event.subject}',
        );
      }
    }

    // Not in class: look for next class today
    final upcomingClasses = todayClasses
        .where((e) => e.startMinutes > currentMinutes)
        .toList();

    if (upcomingClasses.isNotEmpty) {
      final next = upcomingClasses.first;
      final minutesUntil = next.startMinutes - currentMinutes;

      return TimetableState(
        status: TimetableStatus.beforeNextClass,
        nextClass: next,
        daysUntilNext: 0,
        todayClasses: todayClasses,
        minutesUntilNext: minutesUntil,
        statusDescription: 'Next: ${next.subject} in $minutesUntil min',
      );
    }

    // If currentMinutes >= last class end time
    return TimetableState(
      status: TimetableStatus.noMoreClassesToday,
      todayClasses: todayClasses,
      nextClass: upcomingClassInWeek,
      daysUntilNext: daysUntilUpcoming,
      statusDescription: 'No more classes today',
    );
  }
}
