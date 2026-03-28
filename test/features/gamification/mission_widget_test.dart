import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:ekodost/features/feedback/presentation/widgets/mission_widget.dart';

Widget _wrap(Widget child) {
  return Sizer(
    builder: (context, orientation, screenType) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          ),
        ),
      );
    },
  );
}

void main() {
  group('MissionWidget — gamificationEnabled = false', () {
    testWidgets('returns SizedBox.shrink when gamificationEnabled is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 30.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Test Mission',
            missionCompleted: false,
            gamificationEnabled: false,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Çevre Misyonu'), findsNothing);
      expect(find.textContaining('Test Mission'), findsNothing);
    });
  });

  group('MissionWidget — active (not completed)', () {
    testWidgets('renders mission title and header', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 30.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Aylık Tasarruf',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Çevre Misyonu'), findsOneWidget);
      expect(find.text('Aylık Tasarruf'), findsOneWidget);
    });

    testWidgets('renders CO2 stat card', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 30.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Test',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('kg CO₂'), findsOneWidget);
    });

    testWidgets('renders tree equivalence stat card', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 30.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Test',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('ağaç'), findsOneWidget);
    });

    testWidgets('does NOT show completed badge when missionCompleted=false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 30.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Test',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Misyon Tamamlandı'), findsNothing);
    });

    testWidgets('shows progress section label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 30.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Test',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Misyon İlerlemesi'), findsOneWidget);
    });
  });

  group('MissionWidget — completed state', () {
    testWidgets('shows "Misyon Tamamlandı" badge when missionCompleted=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 300.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Tamamlandı Görevi',
            missionCompleted: true,
            gamificationEnabled: true,
          ),
        ),
      );
      // Allow animations to settle
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.textContaining('Misyon Tamamlandı'), findsOneWidget);
    });
  });

  group('MissionWidget — zero savedKWh', () {
    testWidgets('renders without error when savedKWh = 0', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 0.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Zero Test',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Çevre Misyonu'), findsOneWidget);
    });

    testWidgets('CO2 stat shows 0.00 when savedKWh = 0', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MissionWidget(
            savedKWh: 0.0,
            baselineKWh: 300.0,
            periodDays: 30,
            missionTitle: 'Zero Test',
            missionCompleted: false,
            gamificationEnabled: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('0.00'), findsOneWidget);
    });
  });
}
