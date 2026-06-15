import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/widgets/liquid_glass_bottom_bar.dart';

/// A representative bottom bar item set used across multiple tests.
const List<LiquidGlassBottomBarItem> _defaultItems = [
  LiquidGlassBottomBarItem(
    label: 'Inicio',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
  ),
  LiquidGlassBottomBarItem(
    label: 'Notificaciones',
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
  ),
  LiquidGlassBottomBarItem(
    label: 'Perfil',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  ),
];

/// Helper to pump [LiquidGlassBottomBar] in a test harness.
Future<void> pumpBar(WidgetTester tester, {
  int currentIndex = 0,
  List<int>? badgeCounts,
  void Function(int)? onTap,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LiquidGlassBottomBar(
          currentIndex: currentIndex,
          onTap: onTap ?? (_) {},
          items: _defaultItems,
          badgeCounts: badgeCounts,
        ),
      ),
    ),
  );
}

void main() {
  group('LiquidGlassBottomBar', () {
    testWidgets('renders three navigation items', (tester) async {
      await pumpBar(tester);

      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Notificaciones'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('renders default icons', (tester) async {
      await pumpBar(tester);
      await tester.pump(); // let AnimatedSwitcher settle

      // Tab 0 (Inicio) is active → shows activeIcon
      expect(find.byIcon(Icons.home), findsOneWidget);
      // Tabs 1-2 are inactive → show outlined icon
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('shows badge count when provided', (tester) async {
      await pumpBar(tester, badgeCounts: [0, 3, 0]);

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows 99+ for high badge counts', (tester) async {
      await pumpBar(tester, badgeCounts: [0, 150, 0]);

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('hides badge when count is 0', (tester) async {
      await pumpBar(tester, badgeCounts: [0, 0, 0]);

      expect(find.text('0'), findsNothing);
      expect(find.text('99+'), findsNothing);
    });

    testWidgets('fires onTap callback when tapped', (tester) async {
      int tappedIndex = -1;

      await pumpBar(tester, onTap: (i) => tappedIndex = i);

      await tester.tap(find.text('Notificaciones'));
      expect(tappedIndex, 1);
    });

    testWidgets('renders BackdropFilter for glass effect', (tester) async {
      await pumpBar(tester);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('highlights active tab', (tester) async {
      await pumpBar(tester, currentIndex: 2);

      // The active icon (person) should render
      expect(find.byIcon(Icons.person), findsOneWidget);
      // Outlined inactive icons should also exist
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });
  });
}
