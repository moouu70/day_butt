import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

const String kCalorieGoalKey = 'daily_calorie_goal';

class CalorieGoalNotifier extends Notifier<int> {
  @override
  int build() {
    _loadCalorieGoal();
    return AppConstants.defaultCalorieGoal;
  }

  Future<void> _loadCalorieGoal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGoal = prefs.getInt(kCalorieGoalKey);
      if (savedGoal != null && savedGoal > 0) {
        state = savedGoal;
      }
    } catch (_) {}
  }

  Future<void> setCalorieGoal(int goal) async {
    if (goal <= 0) return;
    state = goal;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(kCalorieGoalKey, goal);
    } catch (_) {}
  }
}

final calorieGoalProvider = NotifierProvider<CalorieGoalNotifier, int>(() {
  return CalorieGoalNotifier();
});
