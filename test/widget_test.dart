import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:day_butt/core/widgets/animated_checkbox.dart';
import 'package:day_butt/core/widgets/metric_card.dart';

void main() {
  group('Core Widgets Tests', () {
    testWidgets('MetricCard displays title, value, and icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MetricCard(
                title: 'Calories',
                value: '1,850 kcal',
                subtitle: 'Today',
                icon: LucideIcons.flame,
                iconColor: Colors.orange,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('CALORIES'), findsOneWidget);
      expect(find.text('1,850 kcal'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.byIcon(LucideIcons.flame), findsOneWidget);
    });

    testWidgets('AnimatedCheckbox toggles and calls callback', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AnimatedCheckbox(
                value: false,
                onChanged: (val) {
                  changedValue = val;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedCheckbox), findsOneWidget);
      await tester.tap(find.byType(AnimatedCheckbox));
      await tester.pumpAndSettle();

      expect(changedValue, isTrue);
    });
  });
}
