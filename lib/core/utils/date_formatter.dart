import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFullDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}