import 'package:flutter_test/flutter_test.dart';
import 'package:day_butt/features/university/data/timetable_parser.dart';
import 'package:day_butt/services/timetable_service.dart';
import 'package:day_butt/services/widget_sync_service.dart';

void main() {
  group('WidgetSyncService Payload Builder Tests', () {
    test('Builds payload correctly when in ongoing class', () {
      final now = DateTime(2026, 9, 22, 9, 30); // 09:30 AM (570 min)
      const currentClass = ParsedTimetableEvent(
        id: 'c1',
        dayOfWeek: 2,
        dayName: 'Tuesday',
        startTime: '08:30 AM',
        endTime: '10:30 AM',
        startMinutes: 510,
        endMinutes: 630,
        subject: 'Algorithms & Data Structures',
        type: 'Lecture',
        location: 'Hall 4',
      );

      final timetableState = TimetableService.calculateState(
        allEvents: [currentClass],
        now: now,
      );

      final payload = WidgetSyncService.buildPayload(
        timetableState: timetableState,
        todayCalories: 1450,
        calorieGoal: 2300,
        todayExpenses: 280.0,
        completedRoutines: 4,
        totalRoutines: 5,
        now: now,
      );

      expect(payload['scheduleStatus'], equals('NOW'));
      expect(payload['scheduleTitle'], equals('Algorithms & Data Structures'));
      expect(payload['scheduleSubtitle'], contains('Hall 4'));
      expect(payload['caloriesVal'], contains('1,450'));
      expect(payload['caloriesGoal'], contains('2,300'));
      expect(payload['expensesVal'], contains('EGP 280'));
      expect(payload['routinesVal'], equals('4 / 5'));
      expect(payload['routinesSub'], equals('80% completed'));
    });

    test('Builds payload correctly when before next class', () {
      final now = DateTime(2026, 9, 22, 8, 0); // 08:00 AM (480 min)
      const nextClass = ParsedTimetableEvent(
        id: 'c2',
        dayOfWeek: 2,
        dayName: 'Tuesday',
        startTime: '09:00 AM',
        endTime: '11:00 AM',
        startMinutes: 540,
        endMinutes: 660,
        subject: 'Computer Networks',
        type: 'Lab',
        location: 'Lab 2',
      );

      final timetableState = TimetableService.calculateState(
        allEvents: [nextClass],
        now: now,
      );

      final payload = WidgetSyncService.buildPayload(
        timetableState: timetableState,
        todayCalories: 0,
        calorieGoal: 2000,
        todayExpenses: 0.0,
        completedRoutines: 0,
        totalRoutines: 3,
        now: now,
      );

      expect(payload['scheduleStatus'], equals('NEXT'));
      expect(payload['scheduleTitle'], equals('Computer Networks'));
      expect(payload['scheduleSubtitle'], contains('Starts at'));
      expect(payload['scheduleSubtitle'], contains('Lab 2'));
      expect(payload['expensesSub'], equals('No spend'));
      expect(payload['routinesSub'], equals('0% completed'));
    });

    test('Builds payload correctly when no classes today', () {
      final now = DateTime(2026, 9, 22, 12, 0);
      final timetableState = TimetableService.calculateState(
        allEvents: [],
        now: now,
      );

      final payload = WidgetSyncService.buildPayload(
        timetableState: timetableState,
        todayCalories: 600,
        calorieGoal: 2300,
        todayExpenses: 50.0,
        completedRoutines: 2,
        totalRoutines: 2,
        now: now,
      );

      expect(payload['scheduleStatus'], equals('OFF'));
      expect(payload['scheduleTitle'], equals('No classes scheduled'));
      expect(payload['routinesSub'], equals('100% completed'));
    });
  });
}
