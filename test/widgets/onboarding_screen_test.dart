import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:liquid_glass_app/presentation/screens/onboarding_screen.dart';
import 'package:liquid_glass_app/presentation/widgets/glassmorphism_widget.dart';

/// Pumps [OnboardingScreen] wrapped in a fully-constrained [Scaffold] so
/// that LiquidSwipe and GlassCard render without infinite-constraint issues.
Future<void> pumpOnboarding(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: const Scaffold(
        body: SizedBox(
          height: 800,
          child: OnboardingScreen(),
        ),
      ),
    ),
  );
  // Advance flutter_animate entrance animations (scale 600ms, fadeIn 500ms)
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  group('OnboardingScreen', () {
    // ─── Widget Exists ──────────────────────────────────────────

    testWidgets('renders OnboardingScreen widget', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('renders LiquidSwipe', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byType(LiquidSwipe), findsOneWidget);
    });

    // ─── Page Indicator ─────────────────────────────────────────

    testWidgets('renders page indicator with 3 dots', (tester) async {
      await pumpOnboarding(tester);
      final indicator = tester.widget<AnimatedSmoothIndicator>(
        find.byType(AnimatedSmoothIndicator),
      );
      expect(indicator.count, 3);
    });

    testWidgets('page indicator starts at index 0', (tester) async {
      await pumpOnboarding(tester);
      final indicator = tester.widget<AnimatedSmoothIndicator>(
        find.byType(AnimatedSmoothIndicator),
      );
      expect(indicator.activeIndex, 0);
    });

    // ─── Skip / Start Button ────────────────────────────────────

    testWidgets('renders Saltar text on initial page', (tester) async {
      await pumpOnboarding(tester);
      expect(find.text('Saltar'), findsOneWidget);
    });

    testWidgets('does not render Comenzar on initial page', (tester) async {
      await pumpOnboarding(tester);
      expect(find.text('Comenzar'), findsNothing);
    });

    testWidgets('does not render GlassButton on initial page', (tester) async {
      await pumpOnboarding(tester);
      // GlassButton is conditionally rendered only on the last page
      expect(find.byType(GlassButton), findsNothing);
    });

    testWidgets('Saltar text has correct style', (tester) async {
      await pumpOnboarding(tester);

      final text = tester.widget<Text>(find.text('Saltar'));
      expect(text.style?.fontSize, 16);
      expect(text.style?.fontWeight, FontWeight.w500);
    });

    // ─── First Page Content ─────────────────────────────────────
    // Note: LiquidSwipe renders only the current page, so we can only
    // reliably test the first page's content (page index 0).

    testWidgets('renders first page title Bienvenido', (tester) async {
      await pumpOnboarding(tester);
      expect(find.text('Bienvenido'), findsOneWidget);
    });

    testWidgets('first page title has correct style', (tester) async {
      await pumpOnboarding(tester);

      final title = tester.widget<Text>(find.text('Bienvenido'));
      expect(title.style?.fontSize, 36);
      expect(title.style?.fontWeight, FontWeight.bold);
      expect(title.style?.color, Colors.white);
      expect(title.textAlign, TextAlign.center);
    });

    testWidgets('renders first page subtitle', (tester) async {
      await pumpOnboarding(tester);
      expect(
        find.textContaining('diseño glassmorphism'),
        findsOneWidget,
      );
    });

    testWidgets('renders first page icon', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });

    // ─── GlassCard & Visual Effects ─────────────────────────────

    testWidgets('renders GlassCard for icon background', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byType(GlassCard), findsWidgets);
    });

    testWidgets('GlassCard has custom dimensions 120x120', (tester) async {
      await pumpOnboarding(tester);

      final glassCards = tester.widgetList<GlassCard>(find.byType(GlassCard));
      for (final card in glassCards) {
        expect(card.width, 120);
        expect(card.height, 120);
        expect(card.borderRadius, 30);
      }
    });

    testWidgets('uses BackdropFilter for glass effect', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byType(BackdropFilter), findsWidgets);
    });

    testWidgets('uses ClipRRect for rounded corners', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byType(ClipRRect), findsWidgets);
    });

    // ─── Slide Icon ─────────────────────────────────────────────

    testWidgets('renders slide icon arrow', (tester) async {
      await pumpOnboarding(tester);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    // ─── Gradient Backgrounds ───────────────────────────────────

    testWidgets('pages have linear gradient decoration', (tester) async {
      await pumpOnboarding(tester);

      // At least one Container should have a LinearGradient decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasGradient = containers.any((c) {
        return c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).gradient is LinearGradient;
      });
      expect(hasGradient, isTrue);
    });

    // ─── Edge Cases ─────────────────────────────────────────────

    testWidgets('disposes cleanly without errors', (tester) async {
      await pumpOnboarding(tester);
      await tester.pump();

      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pump();
      // No crash = pass
    });
  });
}
