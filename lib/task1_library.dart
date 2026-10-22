// Завдання 1 — Основи Dart: класи та колекції (модель бібліотеки).

/// Абстрактний базовий клас для будь-якого елемента бібліотеки.
abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  /// Короткий текстовий опис елемента (реалізують нащадки).
  String describe();

  @override
  String toString() => '$runtimeType(${describe()})';
}

/// Книга: "Назва (рік) — автор".
class Book extends LibraryItem {
  final String author;

  const Book({
    required super.title,
    required super.year,
    required this.author,
  });

  @override
  String describe() => '$title ($year) — $author';
}

/// Журнал: "Назва (рік), випуск N".
class Magazine extends LibraryItem {
  final int issueNumber;

  const Magazine({
    required super.title,
    required super.year,
    required this.issueNumber,
  });

  @override
  String describe() => '$title ($year), випуск $issueNumber';
}

/// Бібліотека, що зберігає список елементів.
class Library {
  final List<LibraryItem> _items = [];

  /// Лише для читання: зовнішній код не може змінити список напряму.
  List<LibraryItem> get items => List.unmodifiable(_items);

  /// Додає елемент до бібліотеки.
  void addItem(LibraryItem item) => _items.add(item);

  /// Повертає всі елементи за вказаний рік (порожній список, якщо немає).
  List<LibraryItem> findByYear(int year) =>
      _items.where((item) => item.year == year).toList();

  /// Описи всіх елементів (через .map()).
  List<String> get allDescriptions =>
      _items.map((item) => item.describe()).toList();

  /// Найстаріший елемент або null, якщо бібліотека порожня.
  LibraryItem? findOldest() {
    if (_items.isEmpty) return null; // крайній випадок
    return _items.reduce((a, b) => a.year <= b.year ? a : b);
  }
}

void main() {
  final library = Library();

  // Крайній випадок: порожня бібліотека
  print('Порожня бібліотека, найстаріший: ${library.findOldest()}'); // null

  library.addItem(
      const Book(title: 'Dart у дії', year: 2022, author: 'І. Петренко'));
  library.addItem(const Magazine(title: 'Mobile Dev', year: 2023, issueNumber: 5));
  library.addItem(
      const Book(title: 'Flutter на практиці', year: 2020, author: 'О. Коваль'));

  final from2022 = library.findByYear(2022);
  print('За 2022 рік: $from2022');

  print('Немає елементів за 1999: ${library.findByYear(1999)}'); // []

  print('Всі описи:');
  for (final d in library.allDescriptions) {
    print(' - $d');
  }

  print('Найстаріший: ${library.findOldest()?.describe()}');
}