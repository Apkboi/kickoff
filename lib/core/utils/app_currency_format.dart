/// App-wide money display — product targets Nigeria (Naira).
abstract final class AppCurrencyFormat {
  static String naira(num value, {int fractionDigits = 0}) {
    final s = value.toDouble().toStringAsFixed(fractionDigits);
    return '₦$s';
  }

  static String nairaRange(num min, num max, {int fractionDigits = 0}) {
    return '${naira(min, fractionDigits: fractionDigits)} – ${naira(max, fractionDigits: fractionDigits)}';
  }
}
