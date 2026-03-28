import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:ekodost/features/gamification/presentation/widgets/streak_flame.dart';

Widget _wrap(Widget child) {
  return Sizer(
    builder: (context, orientation, screenType) {
      return MaterialApp(
        home: Scaffold(body: Center(child: child)),
      );
    },
  );
}

void main() {
  group('StreakFlame — gamificationEnabled = false', () {
    testWidgets('returns SizedBox.shrink when gamificationEnabled is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 5,
            streakBroken: false,
            streakFreeze: false,
            gamificationEnabled: false,
          ),
        ),
      );
      await tester.pump();
      // No flame icon, no day count text
      expect(find.byIcon(Icons.local_fire_department_rounded), findsNothing);
      expect(find.textContaining('gün'), findsNothing);
    });
  });

  group('StreakFlame — active state', () {
    testWidgets('renders flame icon and streak day count', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 12,
            streakBroken: false,
            streakFreeze: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.textContaining('12 gün'), findsOneWidget);
    });

    testWidgets('shows "Aktif Seri" label in active state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 7,
            streakBroken: false,
            streakFreeze: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Aktif Seri'), findsOneWidget);
    });
  });

  group('StreakFlame — broken state', () {
    testWidgets('renders flame icon in broken state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 0,
            streakBroken: true,
            streakFreeze: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
    });

    testWidgets('shows "Seri Bitti" label in broken state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 0,
            streakBroken: true,
            streakFreeze: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Seri Bitti'), findsOneWidget);
    });

    testWidgets('broken state takes priority over freeze', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 5,
            streakBroken: true,
            streakFreeze: true, // broken takes priority
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Seri Bitti'), findsOneWidget);
      expect(find.text('Seri Korundu'), findsNothing);
    });
  });

  group('StreakFlame — frozen state', () {
    testWidgets('renders flame icon in frozen state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 5,
            streakBroken: false,
            streakFreeze: true,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
    });

    testWidgets('shows "Seri Korundu" label in frozen state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 5,
            streakBroken: false,
            streakFreeze: true,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Seri Korundu'), findsOneWidget);
    });

    testWidgets('shows streak day count in frozen state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StreakFlame(
            streakDays: 5,
            streakBroken: false,
            streakFreeze: true,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('5 gün'), findsOneWidget);
    });
  });
}
