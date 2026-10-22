import 'package:flutter_test/flutter_test.dart';
import 'package:module_control_1/task3_counter.dart';

void main() {
  testWidgets('початкове значення 0', (tester) async {
    await tester.pumpWidget(const CounterApp());
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('+1 збільшує лічильник', (tester) async {
    await tester.pumpWidget(const CounterApp());
    await tester.tap(find.text('+1'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('DetailScreen отримує значення, а після повернення стан збережений',
      (tester) async {
    await tester.pumpWidget(const CounterApp());

    // Збільшуємо до 3
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('+1'));
      await tester.pump();
    }

    // Переходимо на DetailScreen
    await tester.tap(find.text('Детальніше'));
    await tester.pumpAndSettle();
    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // Повертаємось назад
    await tester.tap(find.text('Назад'));
    await tester.pumpAndSettle();
    expect(find.byType(DetailScreen), findsNothing);
    expect(find.text('3'), findsOneWidget); // не скинувся
  });
}