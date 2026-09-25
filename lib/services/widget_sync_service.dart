import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/date_utils.dart';
import '../features/university/data/timetable_parser.dart';
import 'timetable_service.dart';

class WidgetSyncService {
  static const MethodChannel _channel = MethodChannel('app.day_butt/widget');

  /// Prepares and sends current snapshot data to native Android AppWidget
  static Future<bool> syncWidgetData({
    required List<ParsedTimetableEvent> timetableEvents,
    required int todayCalories,
    required int calorieGoal,
    required double todayExpenses,
    required int completedRoutines,
    required int totalRoutines,
  }) async {
    // Only available on Android
    if (!Platform.isAndroid) return false;

    try {
      final now = DateTime.now();
      final timetableState = TimetableService.calculateState(
        allEvents: timetableEvents,
        now: now,
      );

      final payload = buildPayload(
        timetableState: timetableState,
        todayCalories: todayCalories,
        calorieGoal: calorieGoal,
        todayExpenses: todayExpenses,
        completedRoutines: completedRoutines,
        totalRoutines: totalRoutines,
        now: now,
      );

      await _channel.invokeMethod('updateWidgetData', payload);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Pure helper to generate widget payload for testing and channel invocation
  static Map<String, dynamic> buildPayload({
    required TimetableState timetableState,
    required int todayCalories,
    required int calorieGoal,
    required double todayExpenses,
    required int completedRoutines,
    required int totalRoutines,
    required DateTime now,
  }) {
    String scheduleStatus = 'FREE';
    String scheduleTitle = 'No classes today';
    String scheduleSubtitle = 'Enjoy your free time';

    switch (timetableState.status) {
      case TimetableStatus.inClass:
        scheduleStatus = 'NOW';
        final curr = timetableState.currentClass!;
        scheduleTitle = curr.subject;
        final range = AppDateUtils.formatTimeRange12Hour(curr.startMinutes, curr.endMinutes);
        final loc = curr.location != null && curr.location!.isNotEmpty ? ' • ${curr.location}' : '';
        scheduleSubtitle = '$range$loc (${timetableState.remainingTimeString})';
        break;

      case TimetableStatus.beforeNextClass:
        scheduleStatus = 'NEXT';
        final next = timetableState.nextClass!;
        scheduleTitle = next.subject;
        final start = AppDateUtils.formatMinutes12Hour(next.startMinutes);
        final loc = next.location != null && next.location!.isNotEmpty ? ' • ${next.location}' : '';
        scheduleSubtitle = 'Starts at $start$loc (in ${timetableState.untilNextString})';
        break;

      case TimetableStatus.noMoreClassesToday:
        scheduleStatus = 'FREE';
        scheduleTitle = 'Classes Finished';
        scheduleSubtitle = 'All scheduled classes completed for today';
        break;

      case TimetableStatus.noClassesToday:
        scheduleStatus = 'OFF';
        scheduleTitle = 'No classes scheduled';
        scheduleSubtitle = 'Enjoy your day';
        break;
    }

    final dateText = DateFormat('EEE, MMM d').format(now);
    final caloriesVal = CurrencyFormatter.formatCalories(todayCalories);
    final caloriesGoalStr = 'Goal ${CurrencyFormatter.formatCalories(calorieGoal)}';

    final expensesVal = CurrencyFormatter.formatEGP(todayExpenses);
    final expensesSub = todayExpenses > 0 ? 'Spent today' : 'No spend';

    final routinesVal = '$completedRoutines / $totalRoutines';
    final routinesSub = totalRoutines > 0
        ? '${((completedRoutines / totalRoutines) * 100).toInt()}% completed'
        : 'Completed';

    return {
      'scheduleStatus': scheduleStatus,
      'scheduleTitle': scheduleTitle,
      'scheduleSubtitle': scheduleSubtitle,
      'caloriesVal': caloriesVal,
      'caloriesGoal': caloriesGoalStr,
      'expensesVal': expensesVal,
      'expensesSub': expensesSub,
      'routinesVal': routinesVal,
      'routinesSub': routinesSub,
      'dateText': dateText,
    };
  }
}
