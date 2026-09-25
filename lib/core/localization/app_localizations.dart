import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _values = {
    'en': {
      // Navigation
      'navHome': 'Home',
      'navUni': 'Uni',
      'navCalories': 'Calories',
      'navExpenses': 'Expenses',
      'navRoutine': 'Routine',

      // Home Screen
      'greetingPrefix': 'Good morning',
      'greetingMohammed': 'Mohammed',
      'currentlyIn': 'CURRENTLY IN',
      'nextClass': 'NEXT CLASS',
      'allClassesCompleted': 'All classes completed for today',
      'allClassesCompletedDesc': 'You are done with university classes for today.',
      'noClassesScheduled': 'No classes scheduled today',
      'noClassesScheduledDesc': 'Enjoy your free day or prepare ahead.',
      'noTimetableImported': 'No timetable imported',
      'noTimetableImportedDesc': 'Tap here to import your university schedule',
      'remaining': 'remaining',
      'startsIn': 'Starts in',
      'todaySummary': 'TODAY',
      'todayOverview': 'Today Overview',
      'quickActions': 'Quick Actions',
      'calorie': 'Calories',
      'expense': 'Expense',
      'routine': 'Routine',
      'todo': 'Todo',
      'note': 'Note',
      'todaysRoutines': "Today's Routines",
      'todaysTasks': "Today's Tasks",
      'quickNote': 'Quick Note',
      'viewAll': 'View all',
      'add': '+ Add',
      'noRoutinesConfigured': 'No daily routines configured',
      'allCaughtUp': 'All caught up! No tasks left.',
      'captureThought': 'Capture a thought or reminder...',
      'moreTasks': '+ {count} more',
      'moreNotes': '+ {count} more',
      'showLess': 'Show less',

      // University / Timetable
      'timetable': 'Timetable',
      'today': 'Today',
      'importTimetable': 'Import Timetable',
      'importTimetableJson': 'Import Timetable (JSON)',
      'copyJsonTemplate': 'Copy JSON Template',
      'copyJsonFormat': 'Copy JSON Format',
      'jsonCopied': 'Timetable JSON template copied to clipboard!',
      'myTimetableJsonCopied': 'Your timetable exported to clipboard as JSON!',
      'copyFormat': 'Copy Format',
      'copyCurrentTimetable': 'Copy Current Timetable',
      'pasteJson': 'Paste JSON',
      'importFile': 'Import File',
      'needFormatHelp': 'Need the timetable structure? Copy the ready-to-use JSON format.',
      'noClassesOnDay': 'No classes scheduled for this day',
      'classesCount': 'classes',
      'classCount': 'class',
      'now': 'NOW',

      // Calories
      'calories': 'Calories',
      'dailyGoal': 'Daily Goal',
      'editDailyGoal': 'Edit Daily Goal',
      'calorieGoalHint': 'Daily goal (e.g. 2300)',
      'quickPresets': 'Quick Presets',
      'invalidGoal': 'Please enter a valid number',
      'goalUpdated': 'Calorie goal updated successfully',
      'ofDailyGoal': 'of daily goal',
      'todaysLog': "Today's Log",
      'noCaloriesLogged': 'No calories logged today.',
      'addCalories': '+ Add Calories',
      'calorieEntry': 'Calorie entry',
      'history': 'History',
      'calorieHistory': 'Calorie History',
      'noCalorieHistory': 'No calorie history yet',
      'calorieHistoryDesc': 'Entries you log will automatically appear in your daily timeline history.',
      'entries': 'entries',
      'entry': 'entry',

      // Expenses & Income
      'expenses': 'Expenses',
      'expensesAndIncome': 'Expenses & Income',
      'todaysNetBalance': "TODAY'S NET BALANCE",
      'income': 'Income',
      'net': 'Net',
      'noExpensesToday': 'No expenses today.',
      'noIncomeToday': 'No income today.',
      'noTransactionsToday': 'No transactions recorded today.',
      'addExpense': 'Add Expense',
      'addIncome': 'Add Income',
      'recentExpenses': 'Recent Expenses',
      'recentTransactions': 'Recent Transactions',
      'financialHistory': 'Financial History',
      'all': 'All',

      // Routines
      'routines': 'Routines',
      'todaysProgress': "TODAY'S PROGRESS",
      'completed': 'completed',
      'allDone': 'ALL DONE!',
      'active': 'ACTIVE',
      'dailyChecklist': 'Daily Checklist',
      'noRoutinesYet': 'No routines yet.',
      'noRoutinesDesc': 'Create recurring daily habits to build consistency every day.',
      'createRoutine': 'Create routine',
      'newRoutine': 'New',
      'suggestedRoutines': 'Suggested Routines',
      'suggestedRoutinesDesc': 'Tap to quickly add to your daily checklist',
      'suggestions': 'Suggestions',
      'routineAdded': 'Routine added to checklist',
      'routineAlreadyExists': 'Routine is already in your checklist',
      'undo': 'Undo',

      // Settings & Theming
      'settings': 'Settings',
      'appearance': 'APPEARANCE',
      'themeCenter': 'Theme Center',
      'themeCenterDesc': 'Customize your atmosphere',
      'presets': 'PRESETS',
      'customize': 'CUSTOMIZE',
      'backgrounds': 'BACKGROUNDS',
      'themeDna': 'THEME DNA',
      'themeDnaDesc': 'Use this theme\'s visual identity to create matching artwork with AI.',
      'copyDna': 'Copy DNA',
      'viewDna': 'View DNA',
      'themeDnaCopied': 'Theme DNA copied',
      'themeDnaModalTitle': 'Theme Visual DNA',
      'themeDnaModalDesc': 'Copy this prompt foundation and paste it into any AI image generator.',
      'accentColor': 'Accent Color',
      'resetAccent': 'Reset Accent',
      'glassIntensity': 'Glass Intensity',
      'blurIntensity': 'Blur Intensity',
      'glow': 'Glow',
      'off': 'Off',
      'low': 'Low',
      'medium': 'Medium',
      'high': 'High',
      'minimal': 'Minimal',
      'cinematic': 'Cinematic',
      'none': 'None',
      'resetTheme': 'Reset Theme',
      'resetThemeConfirm': 'Are you sure you want to reset all visual customizations and backgrounds to defaults?',
      'chooseCustomImage': 'Choose from Gallery',
      'removeCustomImage': 'Remove Custom Image',
      'applied': 'Applied',
      'livePreview': 'LIVE PREVIEW',
      'screenBackgrounds': 'Screen Backgrounds',
      'language': 'LANGUAGE',
      'languageTitle': 'Language',
      'english': 'English',
      'arabic': 'العربية',
      'universityTimetable': 'UNIVERSITY TIMETABLE',
      'timetableStatus': 'Timetable Status',
      'importedClasses': 'classes imported',
      'noTimetable': 'No schedule loaded',
      'clearTimetable': 'Clear Timetable',
      'clearTimetableDesc': 'Remove all university events',
      'dataAndBackup': 'DATA & BACKUP',
      'exportJson': 'Export JSON Data',
      'exportJsonDesc': 'Save complete database backup',
      'importJson': 'Import JSON Backup',
      'importJsonDesc': 'Restore records from JSON file',
      'dangerZone': 'DANGER ZONE',
      'clearAllData': 'Clear All Data',
      'clearAllDataDesc': 'Permanently delete all database records',
      'about': 'ABOUT',
      'appTagline': 'Your entire day, beautifully organized.',
      'version': 'Version',
      'followOnX': 'Follow me on X',

      // Sheets & Dialogs
      'amount': 'Amount',
      'category': 'Category',
      'optional': 'optional',
      'cancel': 'Cancel',
      'save': 'Save',
      'saveExpense': 'Save Expense',
      'saveIncome': 'Save Income',
      'saveRoutine': 'Save Routine',
      'saveTodo': 'Save Task',
      'saveNote': 'Save Note',
      'enterValidAmount': 'Please enter a valid amount',
      'enterValidCalories': 'Please enter valid calories',
      'enterName': 'Please enter a name',
      'enterContent': 'Please enter note content',
      'addTransaction': 'Add Transaction',
      'currencyEGP': 'EGP',
      'expenseNoteHint': 'Lunch, Uber, books (optional)',
      'incomeNoteHint': 'Salary, freelance bonus (optional)',
      'catFood': 'Food',
      'catTransport': 'Transport',
      'catUniversity': 'University',
      'catShopping': 'Shopping',
      'catBills': 'Bills',
      'catSalary': 'Salary',
      'catAllowance': 'Allowance',
      'catFreelance': 'Freelance',
      'catGift': 'Gift',
      'catInvestment': 'Investment',
      'catOther': 'Other',
      'confirmDelete': 'Confirm Delete',
      'confirmClear': 'Are you sure you want to delete all data? This cannot be undone.',
      'delete': 'Delete',
      'clear': 'Clear',

      // Saved Expenses & Reordering
      'savedExpenses': 'Saved Expenses',
      'savedExpenseDesc': 'Tap to log instantly',
      'newSavedExpense': 'New Saved Label',
      'addSavedExpense': 'Add Saved Label',
      'editSavedExpense': 'Edit Saved Label',
      'deleteSavedExpense': 'Delete Saved Label',
      'savedExpenseName': 'Expense Name',
      'savedExpenseAmount': 'Price / Amount',
      'savedExpenseAdded': 'Saved expense label added',
      'savedExpenseLogged': 'Logged {name} ({amount})',
      'savedExpenseDeleted': 'Saved label deleted',
      'reorderRoutines': 'Reorder Routines',
      'dragToReorder': 'Hold & drag to reorder',
      'tomorrow': 'Tomorrow',
    },
    'ar': {
      // Navigation
      'navHome': 'الرئيسية',
      'navUni': 'الجدول',
      'navCalories': 'السعرات',
      'navExpenses': 'المصاريف',
      'navRoutine': 'الروتين',

      // Home Screen
      'greetingPrefix': 'صباح الخير',
      'greetingMohammed': 'محمد',
      'currentlyIn': 'الآن في',
      'nextClass': 'المحاضرة القادمة',
      'allClassesCompleted': 'اكتملت جميع المحاضرات اليوم',
      'allClassesCompletedDesc': 'لقد انتهيت من جميع مواعيدك الجامعية لليوم.',
      'noClassesScheduled': 'لا توجد محاضرات مجدولة اليوم',
      'noClassesScheduledDesc': 'استمتع بيومك أو استعد للأيام القادمة.',
      'noTimetableImported': 'لم يتم استيراد جدول جامعي',
      'noTimetableImportedDesc': 'اضغط هنا لاستيراد جدولك الجامعي بسهولة',
      'remaining': 'متبقي',
      'startsIn': 'تبدأ خلال',
      'todaySummary': 'اليوم',
      'todayOverview': 'ملخص اليوم',
      'quickActions': 'إجراءات سريعة',
      'calorie': 'السعرات',
      'expense': 'مصروف',
      'routine': 'روتين',
      'todo': 'مهمة',
      'note': 'ملاحظة',
      'todaysRoutines': 'عادات اليوم',
      'todaysTasks': 'مهام اليوم',
      'quickNote': 'ملاحظة سريعة',
      'viewAll': 'عرض الكل',
      'add': '+ إضافة',
      'noRoutinesConfigured': 'لا توجد عادات يومية محددة',
      'allCaughtUp': 'رائع! لا توجد مهام متبقية.',
      'captureThought': 'دوّن فكرة أو تذكيراً سريعاً...',
      'moreTasks': '+ {count} إضافية',
      'moreNotes': '+ {count} إضافية',
      'showLess': 'عرض أقل',

      // University / Timetable
      'timetable': 'الجدول الدراسي',
      'today': 'اليوم',
      'importTimetable': 'استيراد الجدول',
      'importTimetableJson': 'استيراد الجدول (JSON)',
      'copyJsonTemplate': 'نسخ نموذج JSON',
      'copyJsonFormat': 'نسخ شكل JSON',
      'jsonCopied': 'تم نسخ شكل JSON للجدول إلى الحافظة!',
      'myTimetableJsonCopied': 'تم تصدير جدولك الحالي بصيغة JSON إلى الحافظة!',
      'copyFormat': 'نسخ النموذج',
      'copyCurrentTimetable': 'نسخ جدولي الحالي',
      'pasteJson': 'لصق JSON',
      'importFile': 'استيراد ملف',
      'needFormatHelp': 'تحتاج شكل البيانات؟ انسخ نموذج JSON للبدء والتعديل عليه بسهولة.',
      'noClassesOnDay': 'لا توجد محاضرات في هذا اليوم',
      'classesCount': 'محاضرات',
      'classCount': 'محاضرة',
      'now': 'الآن',

      // Calories
      'calories': 'السعرات الحرارية',
      'dailyGoal': 'الهدف اليومي',
      'editDailyGoal': 'تعديل الهدف اليومي',
      'calorieGoalHint': 'الهدف اليومي (مثال 2300)',
      'quickPresets': 'خيارات سريعة',
      'invalidGoal': 'يرجى إدخال رقم صحيح وموجب',
      'goalUpdated': 'تم تحديث الهدف اليومي بنجاح',
      'ofDailyGoal': 'من الهدف اليومي',
      'todaysLog': 'سجل اليوم',
      'noCaloriesLogged': 'لم يتم تسجيل سعرات اليوم.',
      'addCalories': '+ إضافة سعرات',
      'calorieEntry': 'وجبة مسجلة',
      'history': 'السجل',
      'calorieHistory': 'سجل السعرات',
      'noCalorieHistory': 'لا يوجد سجل سابق للسعرات',
      'calorieHistoryDesc': 'ستظهر الوجبات المسجلة هنا مرتبة بالأيام.',
      'entries': 'وجبات',
      'entry': 'وجبة',

      // Expenses & Income
      'expenses': 'المصاريف',
      'expensesAndIncome': 'المصاريف والدخل',
      'todaysNetBalance': 'صافي اليوم',
      'income': 'الدخل',
      'net': 'الصافي',
      'noExpensesToday': 'لا توجد مصاريف مسجلة اليوم.',
      'noIncomeToday': 'لا يوجد دخل مسجل اليوم.',
      'noTransactionsToday': 'لم تسجل أي معاملات مالية اليوم.',
      'addExpense': 'إضافة مصروف',
      'addIncome': 'إضافة دخل',
      'recentExpenses': 'آخر المصاريف',
      'recentTransactions': 'آخر المعاملات',
      'financialHistory': 'السجل المالي',
      'all': 'الكل',

      // Routines
      'routines': 'الروتين اليومي',
      'todaysProgress': 'إنجاز اليوم',
      'completed': 'مكتمل',
      'allDone': 'أحسنت! اكتملت كلها',
      'active': 'قيد الإنجاز',
      'dailyChecklist': 'قائمة العادات',
      'noRoutinesYet': 'لا توجد عادات بعد.',
      'noRoutinesDesc': 'أنشئ عادات يومية لتبني التزاماً حقيقياً ومستمراً.',
      'createRoutine': 'إنشاء عادة',
      'newRoutine': 'جديد',
      'suggestedRoutines': 'عادات مقترحة',
      'suggestedRoutinesDesc': 'اضغط لإضافة العادة مباشرة إلى قائمتك اليومية',
      'suggestions': 'اقتراحات',
      'routineAdded': 'تمت إضافة العادة إلى قائمتك',
      'routineAlreadyExists': 'هذه العادة مضافة بالفعل في قائمتك',
      'undo': 'تراجع',

      // Settings & Theming
      'settings': 'الإعدادات',
      'appearance': 'المظهر',
      'themeCenter': 'مركز السمات',
      'themeCenterDesc': 'خصص أجواء تطبيقك المفضلة',
      'presets': 'السمات الجاهزة',
      'customize': 'تخصيص',
      'backgrounds': 'الخلفيات',
      'themeDna': 'الهوية البصرية (DNA)',
      'themeDnaDesc': 'استخدم الهوية البصرية للسمة لإنشاء خلفيات متناسقة بالذكاء الاصطناعي.',
      'copyDna': 'نسخ الهوية (DNA)',
      'viewDna': 'معاينة الهوية',
      'themeDnaCopied': 'تم نسخ الهوية البصرية (DNA) إلى الحافظة',
      'themeDnaModalTitle': 'الهوية البصرية للسمة',
      'themeDnaModalDesc': 'انسخ هذا النموذج والصقه في أي أداة ذكاء اصطناعي لإنشاء خلفيات متناسقة.',
      'accentColor': 'اللون الأساسي',
      'resetAccent': 'استعادة اللون الأصلي',
      'glassIntensity': 'كثافة الزجاج',
      'blurIntensity': 'كثافة الضبابية',
      'glow': 'التوهج',
      'off': 'إيقاف',
      'low': 'خفيف',
      'medium': 'متوسط',
      'high': 'قوي',
      'minimal': 'مبسط',
      'cinematic': 'سينمائي',
      'none': 'بدون خلفية',
      'resetTheme': 'إعادة ضبط السمة',
      'resetThemeConfirm': 'هل أنت متأكد من رغبتك في إعادة ضبط السمة وكافة الخلفيات إلى الوضع الافتراضي؟',
      'chooseCustomImage': 'اختيار صورة من المعرض',
      'removeCustomImage': 'إزالة الصورة المخصصة',
      'applied': 'مفعّل',
      'livePreview': 'معاينة حية',
      'screenBackgrounds': 'خلفيات الشاشات',
      'language': 'اللغة',
      'languageTitle': 'لغة التطبيق',
      'english': 'English',
      'arabic': 'العربية',
      'universityTimetable': 'الجدول الجامعي',
      'timetableStatus': 'حالة الجدول',
      'importedClasses': 'محاضرة تم استيرادها',
      'noTimetable': 'لا يوجد جدول مضاف',
      'clearTimetable': 'مسح الجدول الدراسي',
      'clearTimetableDesc': 'حذف كافة المحاضرات والمواعيد الجامعية',
      'dataAndBackup': 'البيانات والنسخ الاحتياطي',
      'exportJson': 'تصدير البيانات (JSON)',
      'exportJsonDesc': 'حفظ نسخة احتياطية لكافة بياناتك',
      'importJson': 'استيراد نسخة احتياطية',
      'importJsonDesc': 'استعادة البيانات من ملف JSON',
      'dangerZone': 'إجراءات حرجة',
      'clearAllData': 'مسح كافة البيانات',
      'clearAllDataDesc': 'حذف شامل ونهائي لجميع السجلات',
      'about': 'حول التطبيق',
      'appTagline': 'يومك بالكامل، مرتب بكل إتقان.',
      'version': 'الإصدار',
      'followOnX': 'تابعني على 𝕏',

      // Sheets & Dialogs
      'amount': 'المبلغ',
      'category': 'التصنيف',
      'optional': 'اختياري',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'saveExpense': 'حفظ المصروف',
      'saveIncome': 'حفظ الدخل',
      'saveRoutine': 'حفظ العادة',
      'saveTodo': 'حفظ المهمة',
      'saveNote': 'حفظ الملاحظة',
      'enterValidAmount': 'يرجى إدخال مبلغ صحيح',
      'enterValidCalories': 'يرجى إدخال سعرات صحيحة',
      'enterName': 'يرجى كتابة الاسم',
      'enterContent': 'يرجى كتابة نص الملاحظة',
      'addTransaction': 'إضافة معاملة',
      'currencyEGP': 'ج.م',
      'expenseNoteHint': 'مثال: غداء، مواصلات، كتب (اختياري)',
      'incomeNoteHint': 'مثال: راتب، مكافأة، عمل حر (اختياري)',
      'catFood': 'طعام',
      'catTransport': 'مواصلات',
      'catUniversity': 'الجامعة',
      'catShopping': 'تسوق',
      'catBills': 'فواتير',
      'catSalary': 'راتب',
      'catAllowance': 'مصروف شخصي',
      'catFreelance': 'عمل حر',
      'catGift': 'هدية',
      'catInvestment': 'استثمار',
      'catOther': 'أخرى',
      'confirmDelete': 'تأكيد الحذف',
      'confirmClear': 'هل أنت متأكد من رغبتك بحذف كافة البيانات؟ لا يمكن التراجع عن هذا الإجراء.',
      'delete': 'حذف',
      'clear': 'مسح',

      // Saved Expenses & Reordering
      'savedExpenses': 'المصاريف المحفوظة',
      'savedExpenseDesc': 'اضغط للتسجيل الفوري',
      'newSavedExpense': 'تصنيف محفوظ جديد',
      'addSavedExpense': 'إضافة تصنيف محفوظ',
      'editSavedExpense': 'تعديل التصنيف المحفوظ',
      'deleteSavedExpense': 'حذف التصنيف المحفوظ',
      'savedExpenseName': 'اسم المصروف',
      'savedExpenseAmount': 'السعر / المبلغ',
      'savedExpenseAdded': 'تمت إضافة التصنيف المحفوظ',
      'savedExpenseLogged': 'تم تسجيل {name} ({amount})',
      'savedExpenseDeleted': 'تم حذف التصنيف المحفوظ',
      'reorderRoutines': 'إعادة ترتيب العادات',
      'dragToReorder': 'اضغط واسحب لإعادة الترتيب',
      'tomorrow': 'غداً',
    },
  };

  String tr(String key, [Map<String, String>? params]) {
    final lang = locale.languageCode == 'ar' ? 'ar' : 'en';
    var text = _values[lang]?[key] ?? _values['en']?[key] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }
    return text;
  }

  String categoryName(String key) {
    switch (key.toLowerCase()) {
      case 'food':
        return tr('catFood');
      case 'transport':
      case 'transportation':
        return tr('catTransport');
      case 'university':
        return tr('catUniversity');
      case 'shopping':
        return tr('catShopping');
      case 'bills':
        return tr('catBills');
      case 'salary':
        return tr('catSalary');
      case 'allowance':
        return tr('catAllowance');
      case 'freelance':
        return tr('catFreelance');
      case 'gift':
        return tr('catGift');
      case 'investment':
        return tr('catInvestment');
      case 'other':
      default:
        return tr('catOther');
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
