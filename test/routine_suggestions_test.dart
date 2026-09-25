import 'package:flutter_test/flutter_test.dart';
import 'package:day_butt/features/routines/data/routine_suggestions.dart';
import 'package:day_butt/database/app_database.dart';
import 'package:day_butt/database/database_provider.dart';

void main() {
  group('Routine Suggestions Tests', () {
    test('Predefined suggestions include requested routines', () {
      final titlesAr = kRoutineSuggestions.map((s) => s.titleAr).toList();

      expect(titlesAr, contains('أذكار الصباح'));
      expect(titlesAr, contains('ورد القراءة'));
      expect(titlesAr, contains('الصلوات الخمس'));
    });

    test('RoutineSuggestion.normalizeText handles various Arabic hamzas and characters', () {
      expect(
        RoutineSuggestion.normalizeText('أذكار الصباح'),
        equals(RoutineSuggestion.normalizeText('اذكار الصباح')),
      );
      expect(
        RoutineSuggestion.normalizeText('إقرأ'),
        equals(RoutineSuggestion.normalizeText('اقرا')),
      );
    });

    test('isAdded recognizes existing routines with normalized matching', () {
      final suggestion = kRoutineSuggestions.firstWhere((s) => s.id == 'morning_athkar');

      final routineItemWithDifferentHamza = DailyRoutineItem(
        routine: Routine(
          id: '1',
          name: 'اذكار الصباح', // Without hamza as user typed
          icon: null,
          preferredTime: '06:00 AM',
          isActive: true,
          sortOrder: 0,
          createdAt: DateTime.now(),
        ),
        isCompleted: false,
      );

      expect(suggestion.isAdded([routineItemWithDifferentHamza]), isTrue);
    });

    test('findMatchingRoutineSuggestion matches both exact and normalized routine names', () {
      final matched1 = findMatchingRoutineSuggestion('أذكار الصباح');
      expect(matched1, isNotNull);
      expect(matched1!.id, equals('morning_athkar'));

      final matched2 = findMatchingRoutineSuggestion('اذكار الصباح');
      expect(matched2, isNotNull);
      expect(matched2!.id, equals('morning_athkar'));

      final matched3 = findMatchingRoutineSuggestion('الصلوات الخمس');
      expect(matched3, isNotNull);
      expect(matched3!.id, equals('five_prayers'));

      final matched4 = findMatchingRoutineSuggestion('ورد القراءة');
      expect(matched4, isNotNull);
      expect(matched4!.id, equals('daily_reading'));
    });
  });
}
