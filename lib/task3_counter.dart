// Завдання 3: два екрани, setState() і передача даних через конструктор.
import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Завдання 3',
      home: HomeScreen(),
    );
  }
}

/// Головний екран: лічильник, кнопка «+1» і кнопка «Детальніше».
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Стан живе у State головного екрана, тому не скидається,
  // коли DetailScreen закривається: HomeScreen весь час залишається в стеку.
  int _counter = 0;

  void _increment() {
    setState(() => _counter++);
  }

  void _openDetails() {
    // Дані передаємо лише через конструктор DetailScreen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(counterValue: _counter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Головний екран')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Поточне значення лічильника:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('+1'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _openDetails,
              child: const Text('Детальніше'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Екран деталей: отримує значення через конструктор і показує його.
class DetailScreen extends StatelessWidget {
  final int counterValue;

  const DetailScreen({super.key, required this.counterValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Деталі')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Значення, передане з головного екрана:'),
            Text(
              '$counterValue',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}