import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String convertToYearDay() => DateFormat('yyyy D').format(this);
}