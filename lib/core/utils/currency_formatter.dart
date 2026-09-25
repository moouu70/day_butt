import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.##');

  /// Formats amount to Egyptian Pound display: e.g. "EGP 245" or "245 ج.م"
  static String formatEGP(double amount, {bool isArabic = false}) {
    final numStr = amount == amount.roundToDouble()
        ? NumberFormat('#,##0').format(amount)
        : _formatter.format(amount);
    return isArabic ? '$numStr ج.م' : 'EGP $numStr';
  }

  /// Formats calorie amount: e.g. "1,850 kcal" or "1,850 سعرة"
  static String formatCalories(int kcal, {bool isArabic = false}) {
    final numStr = NumberFormat('#,##0').format(kcal);
    return isArabic ? '$numStr سعرة' : '$numStr kcal';
  }
}
