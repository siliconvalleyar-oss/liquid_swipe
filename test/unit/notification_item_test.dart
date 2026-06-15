import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_glass_app/domain/models/notification_item.dart';

void main() {
  group('NotificationItem', () {
    test('creates with required fields', () {
      final item = NotificationItem(
        id: 1,
        title: 'Test',
        subtitle: 'Subtitle',
        icon: Icons.notifications,
        color: Colors.blue,
        time: '2h',
      );

      expect(item.id, 1);
      expect(item.title, 'Test');
      expect(item.subtitle, 'Subtitle');
      expect(item.icon, Icons.notifications);
      expect(item.color, Colors.blue);
      expect(item.time, '2h');
    });

    test('default isUnread is true', () {
      final item = NotificationItem(
        id: 1,
        title: 'Test',
        subtitle: 'Subtitle',
        icon: Icons.notifications,
        color: Colors.blue,
        time: '2h',
      );

      expect(item.isUnread, isTrue);
    });

    test('creates with isUnread false', () {
      final item = NotificationItem(
        id: 1,
        title: 'Test',
        subtitle: 'Subtitle',
        icon: Icons.notifications,
        color: Colors.blue,
        time: '2h',
        isUnread: false,
      );

      expect(item.isUnread, isFalse);
    });

    test('can change isUnread after creation', () {
      final item = NotificationItem(
        id: 1,
        title: 'Test',
        subtitle: 'Subtitle',
        icon: Icons.notifications,
        color: Colors.blue,
        time: '2h',
      );

      expect(item.isUnread, isTrue);
      item.isUnread = false;
      expect(item.isUnread, isFalse);
    });

    test('supports multiple items with different IDs', () {
      final items = List.generate(3, (i) => NotificationItem(
        id: i + 1,
        title: 'Item $i',
        subtitle: 'Desc $i',
        icon: Icons.notifications,
        color: Colors.blue,
        time: '${i}h',
      ));

      expect(items.length, 3);
      expect(items[0].id, 1);
      expect(items[1].id, 2);
      expect(items[2].id, 3);
      expect(items[0].title, 'Item 0');
      expect(items[1].title, 'Item 1');
      expect(items[2].title, 'Item 2');
    });
  });
}
