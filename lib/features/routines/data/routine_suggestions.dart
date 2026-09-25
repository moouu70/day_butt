import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../database/database_provider.dart';

class RoutineSuggestion {
  final String id;
  final String titleAr;
  final String titleEn;
  final String? preferredTime;
  final IconData icon;

  const RoutineSuggestion({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.preferredTime,
    required this.icon,
  });

  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;

  bool isAdded(List<DailyRoutineItem> dailyRoutines) {
    final normAr = normalizeText(titleAr);
    final normEn = titleEn.trim().toLowerCase();

    return dailyRoutines.any((item) {
      final nameNorm = normalizeText(item.routine.name);
      final nameLower = item.routine.name.trim().toLowerCase();
      return nameNorm == normAr || nameLower == normEn;
    });
  }

  static String normalizeText(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}

const List<RoutineSuggestion> kRoutineSuggestions = [
  RoutineSuggestion(
    id: 'morning_athkar',
    titleAr: 'أذكار الصباح',
    titleEn: 'Morning Athkar',
    preferredTime: '06:00 AM',
    icon: LucideIcons.sunrise,
  ),
  RoutineSuggestion(
    id: 'five_prayers',
    titleAr: 'الصلوات الخمس',
    titleEn: 'Five Daily Prayers',
    preferredTime: null,
    icon: LucideIcons.sparkles,
  ),
  RoutineSuggestion(
    id: 'daily_reading',
    titleAr: 'ورد القراءة',
    titleEn: 'Daily Reading',
    preferredTime: '08:00 PM',
    icon: LucideIcons.bookOpen,
  ),
  RoutineSuggestion(
    id: 'evening_athkar',
    titleAr: 'أذكار المساء',
    titleEn: 'Evening Athkar',
    preferredTime: '05:00 PM',
    icon: LucideIcons.sunset,
  ),
  RoutineSuggestion(
    id: 'drink_water',
    titleAr: 'شرب الماء',
    titleEn: 'Drink Water',
    preferredTime: null,
    icon: LucideIcons.droplets,
  ),
  RoutineSuggestion(
    id: 'workout',
    titleAr: 'تمارين رياضية',
    titleEn: 'Workout',
    preferredTime: '07:00 AM',
    icon: LucideIcons.dumbbell,
  ),
  RoutineSuggestion(
    id: 'sleep_early',
    titleAr: 'نوم مبكر',
    titleEn: 'Sleep Early',
    preferredTime: '10:30 PM',
    icon: LucideIcons.moon,
  ),
];

RoutineSuggestion? findMatchingRoutineSuggestion(String routineName) {
  final norm = RoutineSuggestion.normalizeText(routineName);
  for (final s in kRoutineSuggestions) {
    if (RoutineSuggestion.normalizeText(s.titleAr) == norm ||
        s.titleEn.trim().toLowerCase() == routineName.trim().toLowerCase()) {
      return s;
    }
  }
  return null;
}
