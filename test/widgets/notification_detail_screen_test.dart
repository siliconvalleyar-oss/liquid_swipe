import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/presentation/screens/notification_detail_screen.dart';

/// Pumps [NotificationDetailScreen] inside a constrained box so that
/// GlassCard(height:null) doesn't cause infinite height errors.
Future<void> pumpDetail(WidgetTester tester, {
  int id = 1,
  Map<String, dynamic>? extra,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 600,
          child: NotificationDetailScreen(
            notificationId: id,
            notificationData: extra,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('NotificationDetailScreen', () {
    testWidgets('renders title and back button', (tester) async {
      await pumpDetail(tester, id: 42);

      expect(find.text('Notificación'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders notification ID in title', (tester) async {
      await pumpDetail(tester, id: 7);
      expect(find.text('Notificación #7'), findsOneWidget);
    });

    testWidgets('renders default icon when no extra data', (tester) async {
      await pumpDetail(tester);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('renders Hero with correct tag', (tester) async {
      await pumpDetail(tester, id: 5);
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'notification-icon-5');
    });

    testWidgets('renders metadata section', (tester) async {
      await pumpDetail(tester, id: 3);

      expect(find.text('Información'), findsOneWidget);
      expect(find.text('#3'), findsOneWidget);
      expect(find.text('Notificación estándar'), findsOneWidget);
      expect(find.text('No leída'), findsOneWidget);
    });

    testWidgets('renders action buttons', (tester) async {
      await pumpDetail(tester);

      expect(find.text('Compartir'), findsOneWidget);
      expect(find.text('Guardar'), findsOneWidget);
      expect(find.text('Eliminar'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('renders with extra notification data', (tester) async {
      await pumpDetail(
        tester,
        id: 99,
        extra: <String, dynamic>{
          'title': 'Mensaje especial',
          'subtitle': 'Este es un mensaje de prueba',
          'time': '2h',
        },
      );

      expect(find.text('Mensaje especial'), findsOneWidget);
      expect(find.text('Este es un mensaje de prueba'), findsOneWidget);
      expect(find.text('2h'), findsOneWidget);
    });

    testWidgets('renders BackdropFilter', (tester) async {
      await pumpDetail(tester);
      expect(find.byType(BackdropFilter), findsWidgets);
    });

    testWidgets('renders default subtitle when no extra data', (tester) async {
      await pumpDetail(tester);
      expect(
        find.text('No hay información adicional disponible para esta notificación.'),
        findsOneWidget,
      );
    });

    testWidgets('displays correct ID in metadata', (tester) async {
      await pumpDetail(tester, id: 42);
      expect(find.text('#42'), findsOneWidget);
    });
  });
}
