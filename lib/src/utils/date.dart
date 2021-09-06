import 'package:intl/intl.dart';

class Date {
  static String format(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime currentDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime? parseDate(String formattedString) {
    final date = DateTime.tryParse(formattedString);
    return (date == null) ? date : DateTime(date.year, date.month, date.day);
  }
}