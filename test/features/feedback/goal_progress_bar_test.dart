import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:ekodost/core/widgets/goal_progress_bar.dart';

/// Wraps a widget in the minimal scaffold required for Sizer + Material.
Widget _wrap(Widget child) {
  return Sizer(
    builder: (context, orientation, screenType) {
      return MaterialApp(
        home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
      );
    },
  );
}

void main() {
  final deadline = DateTime.now().add(const Duration(days: 7));

  group('GoalProgressBar — 0% progress', () {
    testWidgets('renders 0% label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 0.0,
            goalKWh: 300.0,
            currentKWh: 300.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('0%'), findsOneWidget);
    });

    testWidgets('does not show "Hedef Tamamlandı" badge at 0%', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 0.0,
            goalKWh: 300.0,
            currentKWh: 300.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Hedef Tamamlandı'), findsNothing);
    });

    testWidgets('shows kWh remaining at 0%', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 0.0,
            goalKWh: 300.0,
            currentKWh: 300.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      // kWh remaining = max(300 - 300, 0) = 0 → "0.0 kWh kaldı"
      expect(find.textContaining('kWh kaldı'), findsOneWidget);
    });
  });

  group('GoalProgressBar — 50% progress', () {
    testWidgets('renders 50% label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 50.0,
            goalKWh: 300.0,
            currentKWh: 150.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('50%'), findsOneWidget);
    });

    testWidgets('shows kWh remaining at 50%', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 50.0,
            goalKWh: 300.0,
            currentKWh: 150.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('150.0 kWh kaldı'), findsOneWidget);
    });
  });

  group('GoalProgressBar — 100% progress', () {
    testWidgets('renders 100% label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 100.0,
            goalKWh: 300.0,
            currentKWh: 0.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('100%'), findsOneWidget);
    });

    testWidgets('shows "Hedef Tamamlandı" badge at 100%', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 100.0,
            goalKWh: 300.0,
            currentKWh: 0.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Hedef Tamamlandı'), findsOneWidget);
    });

    testWidgets('clamps progress > 100 to 100', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 150.0, // over 100
            goalKWh: 300.0,
            currentKWh: 0.0,
            deadline: deadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('100%'), findsOneWidget);
    });
  });

  group('GoalProgressBar — deadline display', () {
    testWidgets('shows "Süre doldu" for past deadline', (tester) async {
      final pastDeadline = DateTime.now().subtract(const Duration(days: 1));
      await tester.pumpWidget(
        _wrap(
          GoalProgressBar(
            progress: 50.0,
            goalKWh: 300.0,
            currentKWh: 150.0,
            deadline: pastDeadline,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Süre doldu'), findsOneWidget);
    });
  });
}
