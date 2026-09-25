import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/theme/resolver/effective_theme_provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../database/app_database.dart';
import '../../../database/database_provider.dart';
import '../data/timetable_parser.dart';

// AI Prompt that users copy and paste into ChatGPT / Gemini / etc.
const _aiPrompt =
    'You are a university timetable assistant. Convert the timetable I will describe '
    'into a structured JSON response using ONLY this exact format — no extra text, no markdown, just the raw JSON:\n\n'
    '{\n'
    '  "type": "timetable",\n'
    '  "version": 1,\n'
    '  "timezone": "Africa/Cairo",\n'
    '  "university": {\n'
    '    "name": "YOUR_FACULTY_NAME",\n'
    '    "group": "YOUR_GROUP"\n'
    '  },\n'
    '  "events": [\n'
    '    {\n'
    '      "day": "Monday",\n'
    '      "start": "08:30",\n'
    '      "end": "10:30",\n'
    '      "subject": "Subject Name",\n'
    '      "type": "Lecture",\n'
    '      "location": "Room A1",\n'
    '      "instructor": "Dr. Name"\n'
    '    }\n'
    '  ]\n'
    '}\n\n'
    'Rules:\n'
    '- "day" must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday\n'
    '- "start" and "end" must be in HH:mm 24-hour format (e.g. 08:30, 14:00)\n'
    '- "type" can be: Lecture, Lab, Tutorial, Seminar, or any class type\n'
    '- "location" and "instructor" are optional\n'
    '- Output ONLY the JSON — nothing else\n\n'
    'Here is my timetable:\n'
    '[PASTE YOUR TIMETABLE HERE]';

class TimetableImportScreen extends ConsumerStatefulWidget {
  const TimetableImportScreen({super.key});

  @override
  ConsumerState<TimetableImportScreen> createState() =>
      _TimetableImportScreenState();
}

class _TimetableImportScreenState extends ConsumerState<TimetableImportScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _jsonController = TextEditingController();
  TimetableParseResult? _parsedResult;
  String? _errorMessage;
  bool _isLoading = false;
  bool _promptCopied = false;

  // 0 = guide, 1 = paste JSON, 2 = preview & save
  int _currentStep = 0;

  late AnimationController _stepAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _stepAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim = CurvedAnimation(parent: _stepAnim, curve: Curves.easeInOut);
    _stepAnim.forward();
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _stepAnim.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _stepAnim.reverse().then((_) {
      setState(() => _currentStep = step);
      _stepAnim.forward();
    });
  }

  void _copyAiPrompt() {
    VibrationService.vibratePress();
    Clipboard.setData(const ClipboardData(text: _aiPrompt));
    setState(() => _promptCopied = true);
    final colors = ref.read(effectiveThemeProvider).colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(LucideIcons.checkCheck,
                color: colors.universityAccent, size: 18),
            const SizedBox(width: 8),
            const Expanded(
                child: Text('Prompt copied! Paste it into any AI chat.')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.surface,
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    VibrationService.vibratePress();
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _jsonController.text = data.text!;
      setState(() => _errorMessage = null);
    }
  }

  void _validateAndPreview() {
    setState(() {
      _errorMessage = null;
      _parsedResult = null;
    });
    final text = _jsonController.text.trim();
    if (text.isEmpty) {
      setState(
          () => _errorMessage = 'Please paste the JSON response from the AI.');
      return;
    }
    try {
      final result = TimetableParser.parse(text);
      setState(() => _parsedResult = result);
      _goToStep(2);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _saveTimetable() async {
    if (_parsedResult == null) return;
    setState(() => _isLoading = true);
    try {
      final db = ref.read(databaseProvider);
      await db.transaction(() async {
        await db.delete(db.universityEvents).go();
        for (final e in _parsedResult!.events) {
          await db.into(db.universityEvents).insert(
                UniversityEventsCompanion.insert(
                  id: e.id,
                  dayOfWeek: e.dayOfWeek,
                  startMinutes: e.startMinutes,
                  endMinutes: e.endMinutes,
                  subject: e.subject,
                  type: e.type,
                  location: drift.Value(e.location),
                  instructor: drift.Value(e.instructor),
                ),
              );
        }
      });
      if (mounted) {
        final colors = ref.read(effectiveThemeProvider).colors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Done! ${_parsedResult!.events.length} classes imported.'),
            backgroundColor: colors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to save: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = ref.watch(effectiveThemeProvider).colors;
    final titles = ['Import Timetable', 'Paste AI Response', 'Preview & Save'];

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, size: 22),
            onPressed: () {
              if (_currentStep > 0) {
                _goToStep(_currentStep - 1);
              } else {
                context.pop();
              }
            },
          ),
          title: Text(titles[_currentStep], style: AppTypography.pageTitle),
        ),
        body: Column(
          children: [
            _StepIndicator(currentStep: _currentStep, colors: colors),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _buildCurrentStep(loc, colors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations loc, dynamic colors) {
    switch (_currentStep) {
      case 0:
        return _buildGuide(colors);
      case 1:
        return _buildPaste(colors);
      case 2:
        return _buildPreview(colors);
      default:
        return const SizedBox();
    }
  }

  // ─── Step 0: Guide ──────────────────────────────────────────────────────────
  Widget _buildGuide(dynamic colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.universityAccent.withOpacity(0.18),
                  colors.universityAccent.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: colors.universityAccent.withOpacity(0.25)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.universityAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: colors.universityAccent.withOpacity(0.3)),
                  ),
                  child: Icon(LucideIcons.bot,
                      color: colors.universityAccent, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Import with AI — Easy & Fast',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Copy the prompt below, open any AI assistant (ChatGPT, Gemini, Claude…), '
                  'share your timetable, then paste the JSON response back here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // How it works
          _HowItWorksCard(colors: colors),

          const SizedBox(height: 24),

          // Copy prompt button
          _CopyPromptButton(
              copied: _promptCopied, colors: colors, onTap: _copyAiPrompt),

          const SizedBox(height: 14),

          // Continue
          GlassButton(
            label: 'I have the AI response  →',
            height: 50,
            onPressed: () => _goToStep(1),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: Divider(color: colors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('or paste raw JSON',
                    style:
                        TextStyle(color: colors.textMuted, fontSize: 11)),
              ),
              Expanded(child: Divider(color: colors.border)),
            ],
          ),

          const SizedBox(height: 14),

          OutlinedButton.icon(
            onPressed: () => _goToStep(1),
            icon: Icon(LucideIcons.code,
                size: 16, color: colors.textSecondary),
            label: Text('Paste JSON directly',
                style:
                    TextStyle(color: colors.textSecondary, fontSize: 13)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 1: Paste JSON ─────────────────────────────────────────────────────
  Widget _buildPaste(dynamic colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.universityAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(LucideIcons.clipboardPaste,
                      color: colors.universityAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Paste the JSON that the AI gave you, then tap Preview.',
                    style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Code editor
          Container(
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    _errorMessage != null ? colors.danger : colors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: colors.border)),
                  ),
                  child: Row(
                    children: [
                      _dot(colors.danger),
                      const SizedBox(width: 5),
                      _dot(colors.warning),
                      const SizedBox(width: 5),
                      _dot(colors.success),
                      const SizedBox(width: 10),
                      Text('timetable.json',
                          style: TextStyle(
                              color: colors.textMuted,
                              fontSize: 11,
                              fontFamily: 'monospace')),
                      const Spacer(),
                      InkWell(
                        onTap: _pasteFromClipboard,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.clipboardPaste,
                                  size: 13,
                                  color: colors.universityAccent),
                              const SizedBox(width: 4),
                              Text('Paste',
                                  style: TextStyle(
                                      color: colors.universityAccent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() {
                          _jsonController.clear();
                          _errorMessage = null;
                        }),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(LucideIcons.x,
                              size: 14, color: colors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _jsonController,
                    maxLines: 14,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: colors.universityAccent,
                      height: 1.45,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          '{\n  "type": "timetable",\n  "events": [...]\n}',
                      hintStyle: TextStyle(color: colors.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.danger.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.danger.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertTriangle,
                      size: 18, color: colors.danger),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(_errorMessage!,
                        style: AppTypography.metadata
                            .copyWith(color: colors.danger)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          GlassButton(
            label: 'Preview Import  →',
            height: 50,
            onPressed: _validateAndPreview,
          ),

          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: () => _goToStep(0),
            icon: Icon(LucideIcons.arrowLeft,
                size: 14, color: colors.textMuted),
            label: Text('Back to guide',
                style:
                    TextStyle(color: colors.textMuted, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ─── Step 2: Preview & Save ─────────────────────────────────────────────────
  Widget _buildPreview(dynamic colors) {
    final result = _parsedResult;
    if (result == null) return const SizedBox();

    return Column(
      children: [
        // Summary
        Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.success.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(LucideIcons.checkCircle,
                    color: colors.success, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.university.name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary)),
                    Text(
                        '${result.events.length} classes found — looks good!',
                        style: TextStyle(
                            fontSize: 12, color: colors.success)),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: result.events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final e = result.events[index];
              return GlassCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                borderRadius: 12,
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color:
                            colors.universityAccent.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppDateUtils.shortDayName(e.dayOfWeek),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: colors.universityAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.subject,
                              style: AppTypography.cardTitle
                                  .copyWith(fontSize: 13.5)),
                          const SizedBox(height: 2),
                          Text(
                            '${AppDateUtils.formatTimeRange12Hour(e.startMinutes, e.endMinutes)} · ${e.type}'
                            '${e.location != null ? ' · ${e.location}' : ''}',
                            style: AppTypography.metadata,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Save pinned at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.danger.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: colors.danger.withOpacity(0.3)),
                  ),
                  child: Text(_errorMessage!,
                      style: AppTypography.metadata
                          .copyWith(color: colors.danger)),
                ),
                const SizedBox(height: 10),
              ],
              GlassButton(
                label:
                    'Save Timetable (${result.events.length} classes)',
                isLoading: _isLoading,
                height: 52,
                onPressed: _saveTimetable,
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _goToStep(1),
                icon: Icon(LucideIcons.pencil,
                    size: 14, color: colors.textMuted),
                label: Text('Edit JSON',
                    style:
                        TextStyle(color: colors.textMuted, fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ─── Step Indicator ───────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final dynamic colors;
  const _StepIndicator({required this.currentStep, required this.colors});

  @override
  Widget build(BuildContext context) {
    const labels = ['Guide', 'Paste', 'Preview'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(
        children: List.generate(3, (i) {
          final active = i == currentStep;
          final done = i < currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 3,
                        decoration: BoxDecoration(
                          color: (active || done)
                              ? colors.universityAccent
                              : colors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: active
                              ? colors.universityAccent
                              : done
                                  ? colors.textSecondary
                                  : colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < 2) const SizedBox(width: 6),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── How It Works Card ────────────────────────────────────────────────────────
class _HowItWorksCard extends StatelessWidget {
  final dynamic colors;
  const _HowItWorksCard({required this.colors});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (LucideIcons.copy, 'Copy the AI prompt',
          'Tap "Copy AI Prompt" below — it tells any AI exactly what format to use.'),
      (LucideIcons.messageSquare, 'Share your timetable with the AI',
          'Open ChatGPT, Gemini, or Claude. Paste the prompt, then describe or paste your timetable.'),
      (LucideIcons.clipboardPaste, 'Paste the JSON response back',
          'Copy the JSON the AI returns, come back here, paste it, and you\'re done!'),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOW IT WORKS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          ...steps.indexed.map((entry) {
            final i = entry.$1;
            final (icon, title, desc) = entry.$2;
            return Padding(
              padding:
                  EdgeInsets.only(bottom: i < steps.length - 1 ? 16 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.universityAccent.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color:
                              colors.universityAccent.withOpacity(0.3)),
                    ),
                    child: Center(
                        child: Icon(icon,
                            size: 15, color: colors.universityAccent)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary)),
                        const SizedBox(height: 3),
                        Text(desc,
                            style: TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Copy Prompt Button ───────────────────────────────────────────────────────
class _CopyPromptButton extends StatelessWidget {
  final bool copied;
  final dynamic colors;
  final VoidCallback onTap;
  const _CopyPromptButton(
      {required this.copied, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: copied
              ? [
                  colors.success.withOpacity(0.25),
                  colors.success.withOpacity(0.1)
                ]
              : [
                  colors.universityAccent.withOpacity(0.28),
                  colors.universityAccent.withOpacity(0.1)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: copied
              ? colors.success.withOpacity(0.5)
              : colors.universityAccent.withOpacity(0.45),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  copied ? LucideIcons.checkCheck : LucideIcons.copy,
                  size: 20,
                  color:
                      copied ? colors.success : colors.universityAccent,
                ),
                const SizedBox(width: 10),
                Text(
                  copied ? 'Prompt Copied!' : 'Copy AI Prompt',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: copied
                        ? colors.success
                        : colors.universityAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
