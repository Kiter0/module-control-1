// Завдання 4: асинхронний код (Future, async/await, Stream, async*).
import 'dart:math';

/// Сервіс, що імітує отримання даних про погоду.
class WeatherService {
  final Random _random;

  /// Можна передати власний Random (наприклад, з seed для тестів).
  WeatherService({Random? random}) : _random = random ?? Random();

  static const List<String> _conditions = [
    'Сонячно',
    'Хмарно',
    'Дощ',
    'Сніг',
    'Туман',
  ];

  /// Імітує запит до сервера: затримка 1–2 секунди, потім повертає Map.
  /// Якщо [city] порожнє, кидає ArgumentError.
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    // Крайній випадок: порожнє місто або лише пробіли.
    // Перевірка стоїть до затримки: некоректний запит відхиляємо одразу.
    if (city.trim().isEmpty) {
      throw ArgumentError('Місто не вказано');
    }

    // Затримка 1000–1999 мс.
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(1000)));

    return {
      'city': city,
      'temp': _randomTemperature(),
      'condition': _conditions[_random.nextInt(_conditions.length)],
    };
  }

  /// Асинхронний генератор: щосекунди видає випадкову температуру.
  /// Після [times] значень Stream завершується.
  Stream<int> temperatureUpdates({int times = 5}) async* {
    for (var i = 0; i < times; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield _randomTemperature();
    }
  }

  /// Випадкова температура від -20 до +35 °C.
  int _randomTemperature() => _random.nextInt(56) - 20;
}

Future<void> main() async {
  final service = WeatherService();

  // --- 1. Future з async/await та try-catch ---
  print('=== fetchCurrentWeather ===');

  // Успішний запит
  try {
    final weather = await service.fetchCurrentWeather('Київ');
    print(weather); // {city: Київ, temp: ..., condition: ...}
  } catch (e) {
    print('Помилка: $e');
  }

  // Некоректний запит (порожнє місто): очікуємо помилку
  try {
    final weather = await service.fetchCurrentWeather('');
    print(weather);
  } catch (e) {
    print('Помилка: $e'); // Помилка: Invalid argument(s): Місто не вказано
  }

  // --- 2. Stream з await for ---
  print('\n=== temperatureUpdates (await for) ===');
  await for (final temp in service.temperatureUpdates(times: 3)) {
    print('Температура: $temp°C');
  }
  print('Stream завершено');

  // --- 3. Той самий Stream, але через підписку .listen() ---
  print('\n=== temperatureUpdates (.listen) ===');
  final subscription = service.temperatureUpdates(times: 2).listen(
    (temp) => print('Отримано: $temp°C'),
    onError: (Object e) => print('Помилка в Stream: $e'),
    onDone: () => print('Підписка завершена'),
  );

  // Чекаємо, поки Stream закінчиться, інакше main завершиться раніше.
  await subscription.asFuture<void>();
}