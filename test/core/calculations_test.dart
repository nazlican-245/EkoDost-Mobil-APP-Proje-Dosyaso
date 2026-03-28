import 'package:flutter_test/flutter_test.dart';
import 'package:ekodost/core/utils/calculations.dart';

void main() {
  group('calculations.dart — constants', () {
    test('CO2_FACTOR equals 0.45 per spec', () {
      expect(CO2_FACTOR, equals(0.45));
    });

    test('TREE_ABSORPTION equals 21.0 per spec', () {
      expect(TREE_ABSORPTION, equals(21.0));
    });
  });

  // ── co2Saved ────────────────────────────────────────────────────────────

  group('co2Saved()', () {
    test('normal case: baseline > actual → positive co2Saved', () {
      // savedKWh = baselineKWh - actualKWh = 100 - 60 = 40
      // co2Saved = 40 * 0.45 = 18.0
      final result = co2Saved(40.0);
      expect(result, closeTo(18.0, 1e-9));
    });

    test('edge case: actual > baseline → negative co2Saved', () {
      // savedKWh = baselineKWh - actualKWh = 60 - 100 = -40
      // co2Saved = -40 * 0.45 = -18.0
      final result = co2Saved(-40.0);
      expect(result, closeTo(-18.0, 1e-9));
    });

    test('zero consumption: savedKWh = 0 → co2Saved = 0', () {
      final result = co2Saved(0.0);
      expect(result, equals(0.0));
    });

    test('uses CO2_FACTOR constant (0.45)', () {
      expect(co2Saved(1.0), equals(CO2_FACTOR));
    });
  });

  // ── treesEquivalent ─────────────────────────────────────────────────────

  group('treesEquivalent()', () {
    test('spec formula: co2Saved / 21', () {
      // co2Saved = 18.0 kg → trees = 18.0 / 21 ≈ 0.857
      final result = treesEquivalent(18.0);
      expect(result, closeTo(18.0 / 21.0, 1e-9));
    });

    test('zero co2 → zero trees', () {
      expect(treesEquivalent(0.0), equals(0.0));
    });

    test('negative co2 → negative trees (caller should clamp)', () {
      final result = treesEquivalent(-21.0);
      expect(result, closeTo(-1.0, 1e-9));
    });

    test('days parameter is ignored (spec: co2Saved / 21 only)', () {
      // Both calls should return the same result regardless of days
      final r1 = treesEquivalent(21.0, days: 1);
      final r2 = treesEquivalent(21.0, days: 365);
      expect(r1, equals(r2));
      expect(r1, closeTo(1.0, 1e-9));
    });
  });

  // ── goalProgress ────────────────────────────────────────────────────────

  group('goalProgress()', () {
    test('normal case: actualKWh < goalKWh → positive progress', () {
      // goalProgress = ((300 - 200) / 300 * 100).clamp(0, 100) = 33.33...
      final result = goalProgress(300.0, 200.0);
      expect(result, closeTo(100.0 / 3.0, 1e-6));
    });

    test('goalProgress clamped at 100 when actualKWh = 0', () {
      // ((300 - 0) / 300 * 100) = 100 → clamped to 100
      final result = goalProgress(300.0, 0.0);
      expect(result, equals(100.0));
    });

    test('goalProgress clamped at 100 when actualKWh is negative', () {
      final result = goalProgress(300.0, -50.0);
      expect(result, equals(100.0));
    });

    test('goalProgress clamped at 0 when actualKWh >= goalKWh', () {
      // ((300 - 400) / 300 * 100) = -33.33 → clamped to 0
      final result = goalProgress(300.0, 400.0);
      expect(result, equals(0.0));
    });

    test('goalProgress clamped at 0 when actualKWh equals goalKWh', () {
      // ((300 - 300) / 300 * 100) = 0 → exactly 0
      final result = goalProgress(300.0, 300.0);
      expect(result, equals(0.0));
    });

    test('goalProgress returns 0 when goalKWh is zero', () {
      final result = goalProgress(0.0, 100.0);
      expect(result, equals(0.0));
    });

    test('goalProgress returns 0 when goalKWh is negative', () {
      final result = goalProgress(-100.0, 50.0);
      expect(result, equals(0.0));
    });

    test('50% progress: actualKWh = goalKWh / 2', () {
      final result = goalProgress(200.0, 100.0);
      expect(result, closeTo(50.0, 1e-9));
    });
  });

  // ── streak logic ─────────────────────────────────────────────────────────

  group('streak logic', () {
    test('incrementStreak adds 1 to current streak', () {
      expect(incrementStreak(0), equals(1));
      expect(incrementStreak(11), equals(12));
    });

    test('resetStreak returns 0', () {
      expect(resetStreak(), equals(0));
    });

    test('useStreakShield decrements shield count by 1', () {
      expect(useStreakShield(3), equals(2));
      expect(useStreakShield(1), equals(0));
    });

    test('useStreakShield does not go below 0', () {
      expect(useStreakShield(0), equals(0));
    });
  });

  // ── co2FromKWh ───────────────────────────────────────────────────────────

  group('co2FromKWh()', () {
    test('returns kWh * CO2_FACTOR', () {
      expect(co2FromKWh(100.0), closeTo(45.0, 1e-9));
    });

    test('zero kWh → zero CO2', () {
      expect(co2FromKWh(0.0), equals(0.0));
    });
  });
}
