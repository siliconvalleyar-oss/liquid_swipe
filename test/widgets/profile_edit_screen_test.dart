import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/screens/profile_edit_screen.dart';

/// Pumps [ProfileEditScreen] inside a fully-constrained [Scaffold] so that
/// GlassCard(height:null) inside SingleChildScrollView doesn't hit infinite height.
Future<void> pumpScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 600, // fixed test viewport height
          child: const ProfileEditScreen(),
        ),
      ),
    ),
  );
  // Pump a few frames so flutter_animate has a chance to start
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('ProfileEditScreen', () {
    testWidgets('renders title', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Editar Perfil'), findsOneWidget);
    });

    testWidgets('renders back button', (tester) async {
      await pumpScreen(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders avatar with initial letter', (tester) async {
      await pumpScreen(tester);
      expect(find.text('A'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('renders avatar wrapped in Hero', (tester) async {
      await pumpScreen(tester);

      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'profile-avatar');
    });

    testWidgets('renders form field labels', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('Biografía'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
    });

    testWidgets('renders save button', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Guardar Cambios'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('renders pre-filled text values', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Alex Rivera'), findsOneWidget);
      expect(find.textContaining('Desarrollador apasionado'), findsOneWidget);
      expect(find.text('alex@example.com'), findsOneWidget);
    });

    testWidgets('has a disabled email field', (tester) async {
      await pumpScreen(tester);

      final textFields = find.byType(TextField);
      bool hasDisabled = false;
      for (int i = 0; i < tester.widgetList(textFields).length; i++) {
        if (tester.widget<TextField>(textFields.at(i)).enabled == false) {
          hasDisabled = true;
          break;
        }
      }
      expect(hasDisabled, isTrue);
    });

    testWidgets('uses BackdropFilter for glass effect', (tester) async {
      await pumpScreen(tester);
      expect(find.byType(BackdropFilter), findsWidgets);
    });
  });
}
