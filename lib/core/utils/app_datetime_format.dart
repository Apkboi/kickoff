import 'package:intl/intl.dart';

/// Shared date/time labels for fixtures and match detail (uses device locale).
abstract final class AppDateTimeFormat {
  static String kickoffFull(DateTime utcOrLocal) {
    final local = utcOrLocal.toLocal();
    return DateFormat('EEE, d MMM · HH:mm').format(local);
  }

  static String timeOnly(DateTime utcOrLocal) {
    return DateFormat('HH:mm').format(utcOrLocal.toLocal());
  }

  static String dayShort(DateTime k) {
    final local = k.toLocal();
    final now = DateTime.now();
    final t = DateTime(now.year, now.month, now.day);
    final kd = DateTime(local.year, local.month, local.day);
    if (kd == t) return 'Today';
    if (kd == t.add(const Duration(days: 1))) return 'Tomorrow';
    return DateFormat('EEE d MMM').format(local);
  }
}
