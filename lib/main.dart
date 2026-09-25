import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI navigation and status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0C0A14),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Check onboarding status
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    ProviderScope(
      child: DayButtApp(showOnboarding: !onboardingCompleted),
    ),
  );
}

class DayButtApp extends ConsumerStatefulWidget {
  final bool showOnboarding;
  const DayButtApp({super.key, required this.showOnboarding});

  @override
  ConsumerState<DayButtApp> createState() => _DayButtAppState();
}

class _DayButtAppState extends ConsumerState<DayButtApp> {
  late final _router = createRouter(showOnboarding: widget.showOnboarding);

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final activeTheme = ref.watch(effectiveThemeProvider);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: activeTheme.colors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp.router(
      title: 'DAY BUTT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        isArabic: currentLocale.languageCode == 'ar',
        theme: activeTheme,
      ),
      routerConfig: _router,
      locale: currentLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
