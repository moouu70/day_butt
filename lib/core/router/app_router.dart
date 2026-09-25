import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../localization/app_localizations.dart';
import '../services/vibration_service.dart';
import '../widgets/radial_navigation.dart';
import '../../features/calories/presentation/calories_history_screen.dart';
import '../../features/calories/presentation/calories_screen.dart';
import '../../features/expenses/presentation/expenses_history_screen.dart';
import '../../features/expenses/presentation/expenses_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/routines/presentation/routines_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/theme_center/presentation/theme_center_screen.dart';
import '../../features/university/presentation/timetable_import_screen.dart';
import '../../features/university/presentation/university_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MainShellScreen extends StatefulWidget {
  final int initialIndex;
  const MainShellScreen({super.key, this.initialIndex = 2});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      VibrationService.vibrateTab();
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screens = [
      const CaloriesScreen(),
      const UniversityScreen(),
      HomeScreen(onTabSelected: _onTabSelected),
      const ExpensesScreen(),
      const RoutinesScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          RadialFloatingNavigation(
            currentIndex: _currentIndex,
            onSelect: _onTabSelected,
            labelTranslator: (key, fallback) => localizations.tr(key),
          ),
        ],
      ),
    );
  }
}

GoRouter createRouter({required bool showOnboarding}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: showOnboarding ? AppRoutes.onboarding : AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShellScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'settings/theme',
            builder: (context, state) => const ThemeCenterScreen(),
          ),
          GoRoute(
            path: 'university',
            builder: (context, state) => const MainShellScreen(initialIndex: 1),
          ),
          GoRoute(
            path: 'university/import',
            builder: (context, state) => const TimetableImportScreen(),
          ),
          GoRoute(
            path: 'calories',
            builder: (context, state) => const MainShellScreen(initialIndex: 0),
          ),
          GoRoute(
            path: 'calories/history',
            builder: (context, state) => const CaloriesHistoryScreen(),
          ),
          GoRoute(
            path: 'expenses',
            builder: (context, state) => const MainShellScreen(initialIndex: 3),
          ),
          GoRoute(
            path: 'expenses/history',
            builder: (context, state) => const ExpensesHistoryScreen(),
          ),
          GoRoute(
            path: 'routines',
            builder: (context, state) => const MainShellScreen(initialIndex: 4),
          ),
        ],
      ),
    ],
  );
}
