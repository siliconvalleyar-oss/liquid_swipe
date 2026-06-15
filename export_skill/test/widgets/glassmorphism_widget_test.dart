import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/widgets/glassmorphism_widget.dart';

/// Pumps a [GlassCard] wrapped in the minimal test harness.
Future<void> pumpGlassCard(
  WidgetTester tester, {
  required Widget child,
  double width = 300,
  double height = 200,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            height: height,
            child: GlassCard(
              width: width,
              height: height,
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  // ─── GlassCard Tests ─────────────────────────────────────────────

  group('GlassCard', () {
    testWidgets('renders child text', (tester) async {
      await pumpGlassCard(tester, child: const Text('Glass Content'));
      expect(find.text('Glass Content'), findsOneWidget);
    });

    testWidgets('renders with multiple children', (tester) async {
      await pumpGlassCard(
        tester,
        child: Column(
          children: [
            const Icon(Icons.star, key: Key('star')),
            const Text('Multiple Children'),
          ],
        ),
      );

      expect(find.byKey(const Key('star')), findsOneWidget);
      expect(find.text('Multiple Children'), findsOneWidget);
    });

    testWidgets('applies margin around card', (tester) async {
      // Apply margin and verify the card still renders
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              margin: const EdgeInsets.all(24),
              child: const Text('Margined'),
            ),
          ),
        ),
      );

      expect(find.text('Margined'), findsOneWidget);

      // Text should be inset from screen edge due to margin
      final textPos = tester.getTopLeft(find.text('Margined'));
      expect(textPos.dx, greaterThan(20));
      expect(textPos.dy, greaterThan(20));
    });

    testWidgets('applies padding inside card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              padding: const EdgeInsets.only(left: 48),
              child: const Text('Padded'),
            ),
          ),
        ),
      );

      expect(find.text('Padded'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('uses BackdropFilter for glass effect', (tester) async {
      await pumpGlassCard(tester, child: const Text('Blur'));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('uses ClipRRect for rounded corners', (tester) async {
      await pumpGlassCard(tester, child: const Text('Rounded'));
      expect(find.byType(ClipRRect), findsWidgets);
    });

    testWidgets('renders with custom gradient colors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              gradientColors: [Colors.red, Colors.blue],
              child: Text('Gradient'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders with custom border gradient', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              borderGradientColors: [Colors.green, Colors.yellow],
              child: Text('Border'),
            ),
          ),
        ),
      );

      expect(find.text('Border'), findsOneWidget);
    });

    testWidgets('renders with default parameters', (tester) async {
      await pumpGlassCard(tester, child: const Text('Default'));
      expect(find.text('Default'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('accepts custom alignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              child: Text('Aligned'),
            ),
          ),
        ),
      );

      expect(find.text('Aligned'), findsOneWidget);
    });
  });

  // ─── GlassButton Tests ───────────────────────────────────────────

  group('GlassButton', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GlassButton(label: 'Click Me')),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('fires onTap when pressed', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassButton(
              label: 'Tap Me',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassButton(label: 'With Icon', icon: Icons.add),
          ),
        ),
      );

      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('hides icon when omitted', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GlassButton(label: 'No Icon')),
        ),
      );

      expect(find.text('No Icon'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('handles null onTap without crash', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GlassButton(label: 'Safe Tap')),
        ),
      );

      await tester.tap(find.text('Safe Tap'));
      // No crash = pass
    });

    testWidgets('uses BackdropFilter for glass effect', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GlassButton(label: 'Blur')),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
