import 'background_slot.dart';

class ThemeBackgrounds {
  final String? home;
  final String? university;
  final String? calories;
  final String? expenses;
  final String? routine;
  final String? notes;
  final String? settings;

  const ThemeBackgrounds({
    this.home,
    this.university,
    this.calories,
    this.expenses,
    this.routine,
    this.notes,
    this.settings,
  });

  String? forSlot(BackgroundSlot slot) {
    switch (slot) {
      case BackgroundSlot.home:
        return home;
      case BackgroundSlot.university:
        return university;
      case BackgroundSlot.calories:
        return calories;
      case BackgroundSlot.expenses:
        return expenses;
      case BackgroundSlot.routine:
        return routine;
      case BackgroundSlot.notes:
        return notes ?? home;
      case BackgroundSlot.settings:
        return settings;
    }
  }

  ThemeBackgrounds copyWith({
    String? home,
    String? university,
    String? calories,
    String? expenses,
    String? routine,
    String? notes,
    String? settings,
  }) {
    return ThemeBackgrounds(
      home: home ?? this.home,
      university: university ?? this.university,
      calories: calories ?? this.calories,
      expenses: expenses ?? this.expenses,
      routine: routine ?? this.routine,
      notes: notes ?? this.notes,
      settings: settings ?? this.settings,
    );
  }
}
