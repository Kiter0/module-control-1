// Завдання 2: власний Stateless-віджет RatingBadge.
import 'package:flutter/material.dart';

/// Бейдж рейтингу: зірка + число (1 знак після коми) + необов'язковий підпис.
class RatingBadge extends StatelessWidget {
  /// Рейтинг у діапазоні 0.0–5.0 (значення поза діапазоном обмежуються).
  final double rating;

  /// Необов'язковий підпис під рейтингом.
  final String? label;

  const RatingBadge({super.key, required this.rating, this.label});

  // Кольори винесені в константи, щоб не хардкодити їх у кількох місцях.
  static const Color _high = Color(0xFF2E7D32); // зелений
  static const Color _medium = Colors.orange;
  static const Color _low = Color(0xFFC62828); // червоний

  /// Єдине місце, де визначається правило вибору кольору зірки:
  /// >= 4.0 зелений, >= 2.5 оранжевий, інакше червоний.
  static Color colorFor(double rating) {
    if (rating >= 4.0) return _high;
    if (rating >= 2.5) return _medium;
    return _low;
  }

  /// Крайні випадки: NaN -> 0.0, значення поза 0..5 обмежуються.
  double get _safeRating =>
      rating.isNaN ? 0.0 : rating.clamp(0.0, 5.0).toDouble();

  @override
  Widget build(BuildContext context) {
    final value = _safeRating;
    final text = label;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: colorFor(value), size: 28),
            const SizedBox(width: 4),
            Text(
              value.toStringAsFixed(1), // округлення до 1 знака
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Підпис показуємо лише якщо він заданий і не порожній.
        if (text != null && text.isNotEmpty)
          Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

//  Демо-застосунок для запису екрану 

void main() => runApp(const _Task2Demo());

class _Task2Demo extends StatelessWidget {
  const _Task2Demo();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _DemoBar(),
        body: Center(
          child: Wrap(
            spacing: 32,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              RatingBadge(rating: 4.7, label: 'Відмінно'), // зелений
              RatingBadge(rating: 3.0, label: 'Добре'), // оранжевий
              RatingBadge(rating: 1.2), // червоний, без підпису
              RatingBadge(rating: 4.0, label: 'Межа 4.0'), // зелений
              RatingBadge(rating: 2.5, label: 'Межа 2.5'), // оранжевий
              RatingBadge(rating: 7.2, label: 'Поза діапазоном'), // -> 5.0
              RatingBadge(rating: -1, label: 'Від\'ємне'), // -> 0.0
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoBar extends StatelessWidget implements PreferredSizeWidget {
  const _DemoBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      AppBar(title: const Text('Завдання 2: RatingBadge'));
}