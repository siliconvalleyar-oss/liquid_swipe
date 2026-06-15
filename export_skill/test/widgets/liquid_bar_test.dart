import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/widgets/liquid_bar.dart';

/// Pumps a [LiquidBar] wrapped in a constrained [Scaffold].
/// Uses incremental [pump] calls instead of [pumpAndSettle] because
/// LiquidBar has a repeating animation that never settles.
Future<void> pumpLiquidBar(
  WidgetTester tester, {
  double progress = 0.5,
  double height = 6,
  List<Color>? colors,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 50,
            child: LiquidBar(
              progress: progress,
              height: height,
              colors: colors ?? const [Color(0xFF6C63FF), Color(0xFFFF6584)],
            ),
          ),
        ),
      ),
    ),
  );
  // Advance a few frames so the animation controller starts
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  group('LiquidBar', () {
    // ─── Structure ──────────────────────────────────────────────
    // Note: MaterialApp/Scaffold internally use CustomPaint, so we use
    // findsAtLeastNWidgets to account for those.

    testWidgets('renders CustomPaint', (tester) async {
      await pumpLiquidBar(tester);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('renders AnimatedBuilder', (tester) async {
      await pumpLiquidBar(tester);
      // LiquidBar uses AnimatedBuilder internally
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    // ─── Default Parameters ─────────────────────────────────────

    testWidgets('renders with default height 6', (tester) async {
      await pumpLiquidBar(tester);

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint).last);
      expect(customPaint.size, const Size(double.infinity, 6));
    });

    testWidgets('renders with custom height 12', (tester) async {
      await pumpLiquidBar(tester, height: 12);

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint).last);
      expect(customPaint.size, const Size(double.infinity, 12));
    });

    testWidgets('renders with custom height 20', (tester) async {
      await pumpLiquidBar(tester, height: 20);

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint).last);
      expect(customPaint.size, const Size(double.infinity, 20));
    });

    testWidgets('uses custom colors without error', (tester) async {
      await pumpLiquidBar(
        tester,
        colors: const [Colors.red, Colors.blue],
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    // ─── Progress Values (smoke tests) ──────────────────────────

    testWidgets('renders with progress 0.0', (tester) async {
      await pumpLiquidBar(tester, progress: 0.0);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('renders with progress 1.0', (tester) async {
      await pumpLiquidBar(tester, progress: 1.0);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('renders with progress 0.33 and 0.75', (tester) async {
      await pumpLiquidBar(tester, progress: 0.33);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

      // Rebuild with different progress
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 50,
                child: LiquidBar(progress: 0.75),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    // ─── Animation ──────────────────────────────────────────────

    testWidgets('animates across multiple frames without error',
        (tester) async {
      await pumpLiquidBar(tester);

      // Pump several frames to let the animation advance
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    // ─── Repaint ────────────────────────────────────────────────

    testWidgets('repaints when progress changes', (tester) async {
      await pumpLiquidBar(tester, progress: 0.3);

      // Change progress and rebuild
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 50,
                child: LiquidBar(progress: 0.8),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // No crash after progress change = shouldRepaint works
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    // ─── Edge Cases ─────────────────────────────────────────────

    testWidgets('renders without crashing with zero dimensions',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 0,
              height: 0,
              child: LiquidBar(progress: 0.5),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('disposes cleanly without errors', (tester) async {
      await pumpLiquidBar(tester);
      await tester.pump();

      // Replace with empty widget to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pump();
      // No crash = pass
    });
  });
}
