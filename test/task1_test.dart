import 'package:flutter_test/flutter_test.dart';
import 'package:module_control_1/task1_library.dart';

void main() {
  late Library library;

  setUp(() => library = Library());

  test('findOldest повертає null для порожньої бібліотеки', () {
    expect(library.findOldest(), isNull);
  });

  test('findByYear повертає лише елементи потрібного року', () {
    library.addItem(const Book(title: 'A', year: 2022, author: 'X'));
    library.addItem(const Magazine(title: 'B', year: 2023, issueNumber: 1));
    expect(library.findByYear(2022).length, 1);
    expect(library.findByYear(1999), isEmpty);
  });

  test('describe має правильний формат', () {
    const book = Book(title: 'Dart у дії', year: 2022, author: 'І. Петренко');
    const mag = Magazine(title: 'Mobile Dev', year: 2023, issueNumber: 5);
    expect(book.describe(), 'Dart у дії (2022) — І. Петренко');
    expect(mag.describe(), 'Mobile Dev (2023), випуск 5');
  });

  test('findOldest повертає елемент з найменшим роком', () {
    library.addItem(const Book(title: 'New', year: 2023, author: 'X'));
    library.addItem(const Book(title: 'Old', year: 2001, author: 'Y'));
    expect(library.findOldest()!.title, 'Old');
  });
}