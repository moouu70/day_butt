import 'package:flutter_test/flutter_test.dart';
import 'package:day_butt/features/university/data/timetable_parser.dart';
import 'package:day_butt/services/timetable_service.dart';

void main() {
  group('TimetableService', () {
    final mondayEvents = [
      const ParsedTimetableEvent(
        id: 'e1',
        dayOfWeek: 1, // Monday
        dayName: 'Monday',
        startTime: '08:30',
        endTime: '10:30',
        startMinutes: 510,
        endMinutes: 630,
        subject: 'Data Structures',
        type: 'Lecture',
      ),
      const ParsedTimetableEvent(
        id: 'e2',
        dayOfWeek: 1, // Monday
        dayName: 'Monday',
        startTime: '11:00',
        endTime: '13:00',
        startMinutes: 660,
        endMinutes: 780,
        subject: 'Algorithms',
        type: 'Lecture',
      ),
    ];

    test('detects when currently inside a class with progress and remaining time', () {
      // Monday 09:15 -> currentMinutes = 9 * 60 + 15 = 555
      final now = DateTime(2026, 9, 21, 9, 15); // Monday
      assert(now.weekday == 1);

      final state = TimetableService.calculateState(
        allEvents: mondayEvents,
        now: now,
      );

      expect(state.status, equals(TimetableStatus.inClass));
      expect(state.currentClass?.subject, equals('Data Structures'));
      // remaining: 630 - 555 = 75 minutes = 1h 15m
      expect(state.remainingMinutes, equals(75));
      expect(state.remainingTimeString, equals('1h 15m remaining'));
      expect(state.nextClass?.subject, equals('Algorithms'));
      expect(state.progress, greaterThan(0.0));
      expect(state.progress, lessThan(1.0));
    });

    test('detects when waiting before next class', () {
      // Monday 10:45 -> between class 1 (ended at 10:30) and class 2 (starts at 11:00)
      final now = DateTime(2026, 9, 21, 10, 45); // Monday
      assert(now.weekday == 1);

      final state = TimetableService.calculateState(
        allEvents: mondayEvents,
        now: now,
      );

      expect(state.status, equals(TimetableStatus.beforeNextClass));
      expect(state.nextClass?.subject, equals('Algorithms'));
      // minutes until: 660 - (10 * 60 + 45) = 660 - 645 = 15 minutes
      expect(state.minutesUntilNext, equals(15));
      expect(state.untilNextString, equals('15 minutes'));
    });

    test('detects when all classes for today are completed', () {
      // Monday 14:00 -> after last class ended at 13:00
      final now = DateTime(2026, 9, 21, 14, 0); // Monday
      assert(now.weekday == 1);

      final state = TimetableService.calculateState(
        allEvents: mondayEvents,
        now: now,
      );

      expect(state.status, equals(TimetableStatus.noMoreClassesToday));
      expect(state.statusDescription, equals('No more classes today'));
    });

    test('detects when day has no classes scheduled (e.g. Sunday)', () {
      final now = DateTime(2026, 9, 27, 12, 0); // Sunday (weekday 7)
      assert(now.weekday == 7);

      final state = TimetableService.calculateState(
        allEvents: mondayEvents,
        now: now,
      );

      expect(state.status, equals(TimetableStatus.noClassesToday));
      expect(state.statusDescription, equals('No university classes today'));
    });
  });
}
