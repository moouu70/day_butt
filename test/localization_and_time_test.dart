import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_butt/core/localization/app_localizations.dart';
import 'package:day_butt/core/providers/user_provider.dart';
import 'package:day_butt/core/theme/app_theme.dart';
import 'package:day_butt/core/utils/currency_formatter.dart';
import 'package:day_butt/core/utils/date_utils.dart';

void main() {
  group('12-Hour Clock Format Tests', () {
    test('Converts DateTime to 12-hour string with AM/PM', () {
      final morning = DateTime(2026, 9, 22, 8, 30);
      final evening = DateTime(2026, 9, 22, 17, 15);
      final night = DateTime(2026, 9, 22, 21, 30);

      expect(AppDateUtils.formatTime12Hour(morning), contains('08:30'));
      expect(AppDateUtils.formatTime12Hour(morning), contains('AM'));

      expect(AppDateUtils.formatTime12Hour(evening), contains('05:15'));
      expect(AppDateUtils.formatTime12Hour(evening), contains('PM'));

      expect(AppDateUtils.formatTime12Hour(night), contains('09:30'));
      expect(AppDateUtils.formatTime12Hour(night), contains('PM'));
    });

    test('Converts minutes from midnight to 12-hour string', () {
      expect(AppDateUtils.formatMinutes12Hour(510), contains('08:30')); // 8:30 AM
      expect(AppDateUtils.formatMinutes12Hour(510), contains('AM'));

      expect(AppDateUtils.formatMinutes12Hour(1035), contains('05:15')); // 17:15 PM
      expect(AppDateUtils.formatMinutes12Hour(1035), contains('PM'));
    });

    test('Converts range to 12-hour range string', () {
      final range = AppDateUtils.formatTimeRange12Hour(510, 630);
      expect(range, contains('08:30 AM — 10:30 AM'));
    });

    test('Formats remaining duration in English and Arabic', () {
      final eng = AppDateUtils.formatRemainingTime(95, isArabic: false);
      expect(eng, equals('1h 35m remaining'));

      final ar = AppDateUtils.formatRemainingTime(95, isArabic: true);
      expect(ar, contains('متبقي 1 س 35 د'));
    });

    test('Formats starts in countdown in English and Arabic', () {
      final eng = AppDateUtils.formatStartsIn(42, isArabic: false);
      expect(eng, equals('Starts in 42 minutes'));

      final ar = AppDateUtils.formatStartsIn(42, isArabic: true);
      expect(ar, contains('يبدأ خلال 42 دقيقة'));
    });
  });

  group('Localization Tests (English & Arabic)', () {
    test('English translations are accurate', () {
      final loc = AppLocalizations(const Locale('en'));
      expect(loc.tr('navHome'), equals('Home'));
      expect(loc.tr('currentlyIn'), equals('CURRENTLY IN'));
      expect(loc.tr('nextClass'), equals('NEXT CLASS'));
      expect(loc.tr('todaySummary'), equals('TODAY'));
      expect(loc.tr('addCalories'), equals('+ Add Calories'));
      expect(loc.tr('addExpense'), equals('Add Expense'));
      expect(loc.tr('followOnX'), equals('Follow me on X'));
      expect(loc.isArabic, isFalse);
    });

    test('Arabic translations are accurate and natural', () {
      final loc = AppLocalizations(const Locale('ar'));
      expect(loc.tr('navHome'), equals('الرئيسية'));
      expect(loc.tr('currentlyIn'), equals('الآن في'));
      expect(loc.tr('nextClass'), equals('المحاضرة القادمة'));
      expect(loc.tr('todaySummary'), equals('اليوم'));
      expect(loc.tr('addCalories'), equals('+ إضافة سعرات'));
      expect(loc.tr('addExpense'), equals('إضافة مصروف'));
      expect(loc.tr('followOnX'), equals('تابعني على 𝕏'));
      expect(loc.isArabic, isTrue);
    });

    test('Greeting dynamically localized based on time and language', () {
      final morning = DateTime(2026, 9, 22, 9, 0);
      final evening = DateTime(2026, 9, 22, 19, 0);

      expect(AppDateUtils.getGreeting(time: morning, isArabic: false), equals('Good morning'));
      expect(AppDateUtils.getGreeting(time: evening, isArabic: false), equals('Good evening'));

      expect(AppDateUtils.getGreeting(time: morning, isArabic: true), equals('صباح الخير'));
      expect(AppDateUtils.getGreeting(time: evening, isArabic: true), equals('مساء الخير'));
    });
  });

  group('Typography & User Name Tests', () {
    test('AppTheme selects ThmanyahSerif in Arabic mode and Inter in English mode', () {
      final englishTheme = AppTheme.getTheme(isArabic: false);
      final arabicTheme = AppTheme.getTheme(isArabic: true);

      expect(englishTheme.textTheme.bodyMedium?.fontFamily, equals('Inter'));
      expect(arabicTheme.textTheme.bodyMedium?.fontFamily, equals('ThmanyahSerif'));
      expect(arabicTheme.textTheme.bodyMedium?.fontFamilyFallback, contains('ThmanyahSerif'));
    });

    test('UserNameNotifier updates user name properly', () async {
      SharedPreferences.setMockInitialValues({'user_name': 'Ahmed'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Trigger provider initialization
      container.read(userNameProvider);
      // Wait for async _loadUserName to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(container.read(userNameProvider), equals('Ahmed'));

      await container.read(userNameProvider.notifier).setUserName('Fatima');
      expect(container.read(userNameProvider), equals('Fatima'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_name'), equals('Fatima'));
    });
  });

  group('Category & Currency Localization Tests', () {
    test('Category names translate accurately between English and Arabic', () {
      final locEn = AppLocalizations(const Locale('en'));
      final locAr = AppLocalizations(const Locale('ar'));

      expect(locEn.categoryName('Food'), equals('Food'));
      expect(locAr.categoryName('Food'), equals('طعام'));

      expect(locEn.categoryName('Salary'), equals('Salary'));
      expect(locAr.categoryName('Salary'), equals('راتب'));

      expect(locEn.categoryName('Transport'), equals('Transport'));
      expect(locAr.categoryName('Transport'), equals('مواصلات'));

      expect(locEn.categoryName('Freelance'), equals('Freelance'));
      expect(locAr.categoryName('Freelance'), equals('عمل حر'));
    });

    test('CurrencyFormatter formats English and Arabic correctly', () {
      expect(CurrencyFormatter.formatEGP(250, isArabic: false), equals('EGP 250'));
      expect(CurrencyFormatter.formatEGP(250, isArabic: true), equals('250 ج.م'));
      expect(CurrencyFormatter.formatCalories(1850, isArabic: false), equals('1,850 kcal'));
      expect(CurrencyFormatter.formatCalories(1850, isArabic: true), equals('1,850 سعرة'));
    });
  });
}
