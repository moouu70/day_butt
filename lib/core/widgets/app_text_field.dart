import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/resolver/effective_theme_provider.dart';
import '../theme/app_typography.dart';

class AppTextField extends ConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final TextInputType keyboardType;
  final bool autofocus;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.maxLines = 1,
    this.onSubmitted,
    this.onChanged,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(effectiveThemeProvider);
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.metadata.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceSecondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            autofocus: autofocus,
            maxLines: maxLines,
            style: textStyle ?? AppTypography.body.copyWith(color: colors.textPrimary),
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            cursorColor: colors.primary,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.bodyMuted.copyWith(color: colors.textMuted),
              prefixIcon: prefixIcon,
              suffix: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
