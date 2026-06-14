import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/widgets/liquid_bar.dart';

void main() {
  // ─── LiquidBar Widget Tests ─────────────────────────────────────

  group('LiquidBar', () {
    testWidgets('renders AnimatedBuilder wrapper', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(),
          ),
        ),
      );

      // AnimatedBuilder wraps the CustomPaint — verify it exists
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('renders with custom progress value', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(progress: 0.75),
          ),
        ),
      );

      // AnimatedBuilder should still be present for any progress value
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('renders with custom height', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            child: LiquidBar(
              progress: 0.5,
              height: 12,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('renders with custom colors', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(
              progress: 0.3,
              colors: [Colors.amber, Colors.deepOrange],
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('animation advances through frames', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(progress: 0.5),
          ),
        ),
      );

      // Pump multiple frames to advance the repeating animation
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Widget should remain mounted after animation frames
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('works with zero progress', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(progress: 0.0),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('works with full progress', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(progress: 1.0),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('disposes cleanly without errors', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(progress: 0.5),
          ),
        ),
      );

      // Pump some frames to start the animation
      await tester.pump(const Duration(milliseconds: 100));

      // Remove the widget
      await tester.pumpWidget(
        const Material(child: SizedBox.shrink()),
      );

      // Should not throw on dispose
      await tester.pump();
    });

    testWidgets('renders with default progress 0.5', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });

    testWidgets('renders with custom two-color gradient', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: SizedBox(
            width: 200,
            height: 50,
            child: LiquidBar(
              progress: 0.6,
              colors: [Colors.cyan, Colors.teal],
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedBuilder), findsOneWidget);
    });
  });
}
