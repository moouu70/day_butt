import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  static const List<Map<String, dynamic>> _slides = [
    {
      'title': 'Your day,\norganized.',
      'titleAr': 'يومك،\nمرتب بدقة.',
      'subtitle': 'A smart personal operating system designed to keep you in sync with your life.',
      'subtitleAr': 'نظام شخصي ذكي يبقيك متوافقاً مع كل تفاصيل يومك.',
      'tag': 'DAY BUTT',
      'icon': LucideIcons.sparkles,
      'isNameStep': false,
    },
    {
      'title': 'What should we\ncall you?',
      'titleAr': 'ما هو اسمك\nالمفضل؟',
      'subtitle': 'Enter your name to personalize your daily dashboard and greeting.',
      'subtitleAr': 'أدخل اسمك لنخصص لك التحية ولوحة التحكم اليومية.',
      'tag': 'PERSONALIZATION',
      'icon': LucideIcons.userCheck,
      'isNameStep': true,
    },
    {
      'title': 'University. Routines.\nCalories. Expenses.',
      'titleAr': 'الجامعة. العادات.\nالسعرات. المصاريف.',
      'subtitle': 'Track your lecture schedules, daily habits, simple calories, and daily spending in one place.',
      'subtitleAr': 'تابع محاضراتك، عاداتك اليومية، سعراتك، ومصاريفك في مكان واحد وبكل هدوء.',
      'tag': 'LIFE OS',
      'icon': LucideIcons.calendarClock,
      'isNameStep': false,
    },
    {
      'title': 'Everything in\none place.',
      'titleAr': 'كل شيء في\nمكان واحد.',
      'subtitle': 'Completely offline-first. Instant recording in under 5 seconds with zero clutter.',
      'subtitleAr': 'يعمل بدون إنترنت بالكامل. تسجيل فوري في ثوانٍ وبدون أي تشويش.',
      'tag': 'OFFLINE FIRST',
      'icon': LucideIcons.shieldCheck,
      'isNameStep': false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveEnteredName() async {
    final entered = _nameController.text.trim();
    final nameToSave = entered.isNotEmpty ? entered : AppConstants.fallbackUser;
    await ref.read(userNameProvider.notifier).setUserName(nameToSave);
  }

  Future<void> _completeOnboarding() async {
    await _saveEnteredName();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalizations.of(context).isArabic;
    final currentTheme = ref.watch(effectiveThemeProvider);
    final colors = currentTheme.colors;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // Top indicator & Skip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(_slides.length, (index) {
                        final isSelected = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          width: isSelected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    TextButton(
                      onPressed: () => _completeOnboarding(),
                      child: Text(
                        isArabic ? 'تخطي' : 'Skip',
                        style: TextStyle(color: colors.textSecondary),
                      ),
                    ),
                  ],
                ),

                // Page Slider
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                      // Save entered name whenever moving past the name step
                      if (page > 1 && _nameController.text.trim().isNotEmpty) {
                        _saveEnteredName();
                      }
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      final isNameStep = slide['isNameStep'] == true;
                      final title = (isArabic ? slide['titleAr'] : slide['title']) as String;
                      final subtitle = (isArabic ? slide['subtitleAr'] : slide['subtitle']) as String;

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Center(
                              child: Container(
                                width: 104,
                                height: 104,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.surface.withOpacity(0.7),
                                  border: Border.all(
                                    color: colors.primary.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors.primary.withOpacity(0.25),
                                      blurRadius: 28,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    slide['icon'] as IconData,
                                    size: 44,
                                    color: colors.secondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colors.border),
                              ),
                              child: Text(
                                slide['tag'] as String,
                                style: AppTypography.badge.copyWith(
                                  color: colors.secondary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              title,
                              style: AppTypography.pageTitle.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              subtitle,
                              style: AppTypography.bodyMuted.copyWith(fontSize: 14),
                            ),
                            if (isNameStep) ...[
                              const SizedBox(height: 22),
                              AppTextField(
                                controller: _nameController,
                                hintText: isArabic ? 'مثال: محمد' : 'e.g. Mohammed',
                                labelText: isArabic ? 'اسمك' : 'Your Name',
                                autofocus: false,
                                onSubmitted: (_) {
                                  _saveEnteredName();
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Actions
                if (_currentPage < _slides.length - 1)
                  GlassButton(
                    label: isArabic ? 'متابعة' : 'Continue',
                    height: 50,
                    onPressed: () {
                      if (_currentPage == 1 && _nameController.text.trim().isNotEmpty) {
                        _saveEnteredName();
                      }
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                else
                  GlassButton(
                    label: isArabic ? 'يلا نبدأ' : 'Get Started',
                    icon: LucideIcons.arrowRight,
                    height: 50,
                    onPressed: () => _completeOnboarding(),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
