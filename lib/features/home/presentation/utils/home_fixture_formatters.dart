import '../../../../core/utils/app_datetime_format.dart';

abstract final class HomeFixtureFormatters {
  static String timeLabel(DateTime k) => AppDateTimeFormat.timeOnly(k);

  static String dayLabel(DateTime k) => AppDateTimeFormat.dayShort(k);

  /// Full label for hero / cards, e.g. "Wed, 3 Apr · 14:30".
  static String kickoffFull(DateTime k) => AppDateTimeFormat.kickoffFull(k);

  static String shortCode(String name) {
    final s = name.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (s.length >= 3) return s.substring(0, 3);
    if (s.isEmpty) return '??';
    return s.padRight(3, 'X');
  }

  static String desktopDayLabel(DateTime k) => AppDateTimeFormat.dayShort(k);
}
