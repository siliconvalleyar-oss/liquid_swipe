import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:liquid_glass_app/presentation/screens/home_screen.dart';

/// Pumps [HomeScreen] wrapped in a [ProviderScope] + constrained scaffold.
/// [ProviderScope] is required because [_ThemeToggleButton] is a
/// [ConsumerWidget] that accesses [themeModeProvider] and
/// [themeOverlayProvider] via Riverpod.
///
/// HomeScreen also has a Timer.periodic auto-scroll and LiquidBar with
/// repeating animation, so we use incremental [pump] instead of
/// [pumpAndSettle].
Future<void> pumpHome(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: const Scaffold(
          body: SizedBox(
            height: 900,
            child: HomeScreen(),
          ),
        ),
      ),
    ),
  );
  // Advance flutter_animate entrance animations
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  group('HomeScreen', () {
    // ─── Structure ──────────────────────────────────────────────

    testWidgets('renders HomeScreen widget', (tester) async {
      await pumpHome(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('renders Scaffold', (tester) async {
      await pumpHome(tester);
      // HomeScreen returns its own Scaffold (nested inside test wrapper's Scaffold)
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('renders SingleChildScrollView', (tester) async {
      await pumpHome(tester);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    // ─── Header ────────────────────────────────────────────────

    testWidgets('renders welcome title', (tester) async {
      await pumpHome(tester);
      expect(find.text('¡Bienvenido!'), findsOneWidget);
    });

    testWidgets('renders subtitle text', (tester) async {
      await pumpHome(tester);
      expect(find.text('Explora los efectos visuales'), findsOneWidget);
    });

    testWidgets('renders person icon in header', (tester) async {
      await pumpHome(tester);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    // ─── Liquid Bar Section ────────────────────────────────────

    testWidgets('renders progress card with LiquidBar', (tester) async {
      await pumpHome(tester);
      expect(find.text('Progreso del proyecto'), findsOneWidget);
      expect(find.text('68%'), findsOneWidget);
    });

    // ─── Feature Carousel ──────────────────────────────────────

    testWidgets('renders feature carousel section title', (tester) async {
      await pumpHome(tester);
      expect(find.text('Características'), findsOneWidget);
    });

    testWidgets('renders PageView for carousel', (tester) async {
      await pumpHome(tester);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('renders SmoothPageIndicator', (tester) async {
      await pumpHome(tester);
      expect(find.byType(SmoothPageIndicator), findsOneWidget);
    });

    // ─── Stats Row ─────────────────────────────────────────────

    testWidgets('renders stats values', (tester) async {
      await pumpHome(tester);
      expect(find.text('128'), findsOneWidget);
      expect(find.text('2.4k'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
    });

    testWidgets('renders stats labels', (tester) async {
      await pumpHome(tester);
      expect(find.text('Likes'), findsOneWidget);
      expect(find.text('Visitas'), findsOneWidget);
      expect(find.text('Rating'), findsOneWidget);
    });

    testWidgets('renders stats icons', (tester) async {
      await pumpHome(tester);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    // ─── Squad Section ─────────────────────────────────────────

    testWidgets('renders squad section title', (tester) async {
      await pumpHome(tester);
      expect(find.text('Squad - Equipo'), findsOneWidget);
    });

    // ─── Activity Section ──────────────────────────────────────

    testWidgets('renders activity section title', (tester) async {
      await pumpHome(tester);
      expect(find.text('Actividad Reciente'), findsOneWidget);
    });

    testWidgets('renders activity items', (tester) async {
      await pumpHome(tester);
      expect(find.text('Instalación completada'), findsOneWidget);
      expect(find.text('Nuevo miembro'), findsOneWidget);
      expect(find.text('Actualización v2.0'), findsOneWidget);
    });

    testWidgets('renders activity subtitles', (tester) async {
      await pumpHome(tester);
      expect(find.text('Hace 2 minutos'), findsOneWidget);
      expect(find.text('Hace 15 minutos'), findsOneWidget);
      expect(find.text('Hace 1 hora'), findsOneWidget);
    });

    // ─── Feature Card Content (visible pages only) ────────────
    // Note: PageView.builder lazily renders visible + adjacent pages.
    // With viewportFraction: 0.85, only pages 0-1 are initially built.

    testWidgets('renders first feature card title and icon', (tester) async {
      await pumpHome(tester);
      // Page 0 (Glassmorphism) is always rendered
      expect(find.text('Glassmorphism'), findsOneWidget);
      expect(find.byIcon(Icons.blur_on), findsOneWidget);
    });

    // ─── Edge Cases ────────────────────────────────────────────

    testWidgets('disposes cleanly without errors', (tester) async {
      await pumpHome(tester);
      await tester.pump();

      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pump();
      // No crash = pass
    });
  });
}
