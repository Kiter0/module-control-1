import 'package:flutter_test/flutter_test.dart';
import 'package:module_control_1/task4_weather.dart';

void main() {
  final service = WeatherService();

  test('fetchCurrentWeather повертає Map з потрібними ключами', () async {
    final weather = await service.fetchCurrentWeather('Київ');
    expect(weather['city'], 'Київ');
    expect(weather['temp'], isA<int>());
    expect(weather['condition'], isA<String>());
  });

  test('порожнє місто кидає ArgumentError', () {
    expect(
      () => service.fetchCurrentWeather(''),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('місто з пробілів також кидає ArgumentError', () {
    expect(
      () => service.fetchCurrentWeather('   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('temperatureUpdates видає рівно times значень і завершується', () async {
    final values = await service.temperatureUpdates(times: 3).toList();
    expect(values.length, 3);
    for (final t in values) {
      expect(t, inInclusiveRange(-20, 35));
    }
  });

  test('temperatureUpdates(times: 0) повертає порожній Stream', () async {
    final values = await service.temperatureUpdates(times: 0).toList();
    expect(values, isEmpty);
  });
}