import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:module_control_1/task2_rating_badge.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('показує рейтинг з 1 знаком і підпис', (tester) async {
    await tester.pumpWidget(
        _wrap(const RatingBadge(rating: 4.66, label: 'Відмінно')));
    expect(find.text('4.7'), findsOneWidget);
    expect(find.text('Відмінно'), findsOneWidget);
  });

  testWidgets('без label підпис не відображається', (tester) async {
    await tester.pumpWidget(_wrap(const RatingBadge(rating: 1.2)));
    expect(find.text('1.2'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget); // лише число
  });

  testWidgets('рейтинг поза діапазоном обмежується', (tester) async {
    await tester.pumpWidget(_wrap(const RatingBadge(rating: 9)));
    expect(find.text('5.0'), findsOneWidget);
  });

  test('colorFor: межі кольорів', () {
    expect(RatingBadge.colorFor(4.0), RatingBadge.colorFor(5.0)); // зелений
    expect(RatingBadge.colorFor(2.5), Colors.orange);
    expect(RatingBadge.colorFor(3.99), Colors.orange);
    expect(RatingBadge.colorFor(2.49), isNot(Colors.orange));
    expect(RatingBadge.colorFor(0), RatingBadge.colorFor(1.2)); // червоний
  });

  testWidgets('колір зірки відповідає правилу', (tester) async {
    await tester.pumpWidget(_wrap(const RatingBadge(rating: 3.0)));
    final icon = tester.widget<Icon>(find.byIcon(Icons.star));
    expect(icon.color, Colors.orange);
  });
}