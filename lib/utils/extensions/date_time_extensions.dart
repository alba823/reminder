import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toYearDay() => DateFormat('yyyy D').format(this);
  String toMonthDayYear() => DateFormat('MMMM dd yyyy').format(this);
  String toTime() => DateFormat('hh:mm').format(this);

  String get monthDateYearString => toString().split(" ").first;
  String get timeString => toString().split(" ").last;
}