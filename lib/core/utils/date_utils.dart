import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static String _resolveLocale(String? locale, BuildContext? context) {
    if (locale != null) return locale;
    if (context != null) {
      try {
        return Localizations.localeOf(context).languageCode;
      } catch (_) {}
    }
    return 'en';
  }

  static DateFormat _safeDateFormat(String pattern, String? locale, BuildContext? context) {
    final loc = _resolveLocale(locale, context);
    if (loc == 'en') {
      return DateFormat(pattern);
    }
    try {
      return DateFormat(pattern, loc);
    } catch (_) {
      return DateFormat(pattern);
    }
  }

  /// Centralized 12-hour time formatter for DateTime: "08:30 AM" or "05:15 PM"
  static String formatTime12Hour(DateTime date, {String? locale, BuildContext? context}) {
    return _safeDateFormat('hh:mm a', locale, context).format(date);
  }

  /// Converts minutes from midnight (e.g. 510) to 12-hour string: "08:30 AM"
  static String formatMinutes12Hour(int minutes, {String? locale, BuildContext? context}) {
    final clamped = minutes % 1440;
    final h = clamped ~/ 60;
    final m = clamped % 60;
    final dt = DateTime(2026, 1, 1, h, m);
    return _safeDateFormat('hh:mm a', locale, context).format(dt);
  }

  /// Converts start & end minutes to 12-hour range: "08:30 AM — 10:30 AM"
  static String formatTimeRange12Hour(int startMinutes, int endMinutes, {String? locale, BuildContext? context}) {
    final start = formatMinutes12Hour(startMinutes, locale: locale, context: context);
    final end = formatMinutes12Hour(endMinutes, locale: locale, context: context);
    return '$start — $end';
  }

  /// Backward-compatible alias for formatTime -> always 12-hour
  static String formatTime(DateTime date, {String? locale, BuildContext? context}) {
    return formatTime12Hour(date, locale: locale, context: context);
  }

  /// Backward-compatible alias for formatMinutes -> always 12-hour
  static String formatMinutes(int minutes, {bool use24Hour = false, String? locale, BuildContext? context}) {
    return formatMinutes12Hour(minutes, locale: locale, context: context);
  }

  /// Locale-aware date: "Tuesday, September 22" or "الثلاثاء، 22 سبتمبر"
  static String formatDate(DateTime date, {String? locale, BuildContext? context}) {
    return _safeDateFormat('EEEE, MMMM d', locale, context).format(date);
  }

  /// Short locale-aware date: "Sep 22" or "22 سبتمبر"
  static String formatShortDate(DateTime date, {String? locale, BuildContext? context}) {
    return _safeDateFormat('MMM d', locale, context).format(date);
  }

  /// Converts "08:30" string (24-hour machine format) to minutes from midnight
  static int parseTimeToMinutes(String timeStr) {
    final parts = timeStr.trim().split(':');
    if (parts.length != 2) return 0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return (h * 60) + m;
  }

  /// Formats remaining duration: "1h 35m remaining" / "متبقي 1 س 35 د"
  static String formatRemainingTime(int remainingMinutes, {bool isArabic = false}) {
    if (remainingMinutes <= 0) {
      return isArabic ? '0 د متبقية' : '0m remaining';
    }
    final h = remainingMinutes ~/ 60;
    final m = remainingMinutes % 60;
    if (isArabic) {
      if (h > 0 && m > 0) {
        return 'متبقي $h س $m د';
      } else if (h > 0) {
        return 'متبقي $h س';
      } else {
        return 'متبقي $m د';
      }
    } else {
      if (h > 0 && m > 0) {
        return '${h}h ${m}m remaining';
      } else if (h > 0) {
        return '${h}h remaining';
      } else {
        return '${m}m remaining';
      }
    }
  }

  /// Formats countdown until next class: "Starts in 42 minutes" / "يبدأ خلال 42 دقيقة"
  static String formatStartsIn(int minutesUntilNext, {bool isArabic = false}) {
    if (minutesUntilNext <= 0) {
      return isArabic ? 'يبدأ الآن' : 'Starting now';
    }
    final h = minutesUntilNext ~/ 60;
    final m = minutesUntilNext % 60;
    if (isArabic) {
      if (h > 0 && m > 0) {
        return 'يبدأ خلال $h س و $m دقيقة';
      } else if (h > 0) {
        return 'يبدأ خلال $h ساعة';
      } else {
        return 'يبدأ خلال $m دقيقة';
      }
    } else {
      if (h > 0 && m > 0) {
        return 'Starts in ${h}h ${m}m';
      } else if (h > 0) {
        return 'Starts in $h hour';
      } else {
        return 'Starts in $m minutes';
      }
    }
  }

  /// Day of week (1 = Monday, 7 = Sunday) to day name
  static String dayName(int dayOfWeek, {String? locale}) {
    final clamped = ((dayOfWeek - 1) % 7) + 1;
    // 2024-01-01 is Monday (1) ... 2024-01-07 is Sunday (7)
    final target = DateTime(2024, 1, clamped, 12, 0);
    return _safeDateFormat('EEEE', locale, null).format(target);
  }

  /// Short day name (Mon, Tue, etc.)
  static String shortDayName(int dayOfWeek, {String? locale}) {
    final clamped = ((dayOfWeek - 1) % 7) + 1;
    final target = DateTime(2024, 1, clamped, 12, 0);
    return _safeDateFormat('E', locale, null).format(target);
  }

  static int dayNameToWeekday(String name) {
    var s = name.trim().toLowerCase();
    // Normalize Arabic diacritics and letters
    s = s
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ـ', '');

    if (s.startsWith('ال') && s.length > 2) {
      s = s.substring(2);
    }

    switch (s) {
      case 'monday':
      case 'mon':
      case 'اثنين':
      case 'الإثنين':
      case 'الاثنين':
        return 1;
      case 'tuesday':
      case 'tue':
      case 'تلات':
      case 'ثلاثاء':
      case 'الثلاثاء':
        return 2;
      case 'wednesday':
      case 'wed':
      case 'اربعاء':
      case 'الاربعاء':
      case 'الأربعاء':
        return 3;
      case 'thursday':
      case 'thu':
      case 'خميس':
      case 'الخميس':
        return 4;
      case 'friday':
      case 'fri':
      case 'جمعه':
      case 'جمعة':
      case 'الجمعة':
      case 'الجمعه':
        return 5;
      case 'saturday':
      case 'sat':
      case 'سبت':
      case 'السبت':
        return 6;
      case 'sunday':
      case 'sun':
      case 'احد':
      case 'الأحد':
      case 'الاحد':
        return 7;
      default:
        return 1;
    }
  }

  /// Dynamic greeting based on the hour of day
  static String getGreeting({DateTime? time, bool isArabic = false}) {
    final hour = (time ?? DateTime.now()).hour;
    if (isArabic) {
      if (hour >= 5 && hour < 12) {
        return 'صباح الخير';
      } else if (hour >= 12 && hour < 17) {
        return 'طاب مساؤك';
      } else if (hour >= 17 && hour < 22) {
        return 'مساء الخير';
      } else {
        return 'تصبح على خير';
      }
    } else {
      if (hour >= 5 && hour < 12) {
        return 'Good morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Good afternoon';
      } else if (hour >= 17 && hour < 22) {
        return 'Good evening';
      } else {
        return 'Good night';
      }
    }
  }

  /// Format date for database key: YYYY-MM-DD
  static String toDateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
