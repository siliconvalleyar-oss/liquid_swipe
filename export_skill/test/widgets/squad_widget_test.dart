import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/widgets/squad_widget.dart';

/// Helper to pump a SquadWidget and advance the stagger animation
/// enough to resolve initial opacity without completing the full cycle.
Future<void> pumpSquad(WidgetTester tester, {int itemCount = 6}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SquadWidget(itemCount: itemCount),
        ),
      ),
    ),
  );
  // Advance the stagger entrance animation (< 1200ms to avoid triggering
  // the Future.delayed timer from the animation-completed status listener)
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void main() {
  group('SquadWidget', () {
    testWidgets('renders Wrap layout', (tester) async {
      await pumpSquad(tester, itemCount: 4);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('renders correct number of cards', (tester) async {
      await pumpSquad(tester, itemCount: 4);

      // 4 GestureDetectors = 4 interactive cards
      expect(find.byType(GestureDetector), findsNWidgets(4));
    });

    testWidgets('renders with default 6 cards', (tester) async {
      await pumpSquad(tester);
      expect(find.byType(GestureDetector), findsNWidgets(6));
    });

    testWidgets('renders with custom itemCount=2', (tester) async {
      await pumpSquad(tester, itemCount: 2);
      expect(find.byType(GestureDetector), findsNWidgets(2));
    });

    testWidgets('renders card labels', (tester) async {
      await pumpSquad(tester, itemCount: 3);

      // Text exists in the widget tree even before animation completes
      // (it's just transparent/offscreen)
      expect(find.text('Proyectos'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Desarrollo'), findsOneWidget);
    });

    testWidgets('renders item count text', (tester) async {
      await pumpSquad(tester, itemCount: 2);

      // Card 0 shows "3 items", Card 1 shows "6 items"
      expect(find.text('3 items'), findsOneWidget);
      expect(find.text('6 items'), findsOneWidget);
    });

    testWidgets('renders card icons', (tester) async {
      await pumpSquad(tester, itemCount: 3);

      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
      expect(find.byIcon(Icons.insights), findsOneWidget);
      expect(find.byIcon(Icons.code), findsOneWidget);
    });

    testWidgets('has BackdropFilter per card', (tester) async {
      await pumpSquad(tester, itemCount: 2);
      expect(find.byType(BackdropFilter), findsNWidgets(2));
    });

    testWidgets('has ClipRRect per card', (tester) async {
      await pumpSquad(tester, itemCount: 3);
      expect(find.byType(ClipRRect), findsNWidgets(3));
    });

    testWidgets('disposes cleanly without errors', (tester) async {
      await pumpSquad(tester, itemCount: 2);
      await tester.pump();

      // Replace with empty widget to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pump();
      // No crash = pass
    });

    testWidgets('renders all 6 different icons with default count',
        (tester) async {
      await pumpSquad(tester);

      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
      expect(find.byIcon(Icons.insights), findsOneWidget);
      expect(find.byIcon(Icons.code), findsOneWidget);
      expect(find.byIcon(Icons.palette), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.byIcon(Icons.sports_esports), findsOneWidget);
    });

    testWidgets('responds to tap without crash', (tester) async {
      await pumpSquad(tester, itemCount: 2);
      await tester.pump();

      // Tap the first card (may produce a warning if off-screen due to animation,
      // but the callback should still execute)
      await tester.tap(
        find.byType(GestureDetector).first,
        warnIfMissed: false,
      );
      await tester.pump();
    });
  });
}
