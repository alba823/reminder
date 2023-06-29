import 'dart:math';

import 'package:floor/floor.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';

@Entity(tableName: "events", indices: [
  Index(value: ['id'], unique: true)
])
class Event {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isChecked;
  final DateTime timeStamp;
  final String date;
  final int notificationId;
  final bool shouldShowNotification;

  Event(this.id, this.name, this.isChecked, this.timeStamp, this.date,
      this.notificationId, this.shouldShowNotification);

  factory Event.optional(
          {int? id,
          required String name,
          bool? isChecked,
          DateTime? timeStamp,
          String? date,
          int? notificationId,
          bool? shouldShowNotification}) =>
      Event(
          id,
          name,
          isChecked ?? false,
          timeStamp ?? DateTime.now(),
          date ?? timeStamp?.toYearDay() ?? DateTime.now().toYearDay(),
          notificationId ?? Random().nextInt(9999),
          shouldShowNotification ?? true);

  Event copyWith(
      {String? name,
      bool? isChecked,
      DateTime? timeStamp,
      String? date,
      bool? shouldShowNotification}) {
    return Event.optional(
        id: id,
        name: name ?? this.name,
        isChecked: isChecked ?? this.isChecked,
        timeStamp: timeStamp ?? this.timeStamp,
        date: date ?? this.date,
        notificationId: notificationId,
        shouldShowNotification:
            shouldShowNotification ?? this.shouldShowNotification);
  }

  @override
  String toString() {
    return "Event(id: $id, name: $name, isChecked: $isChecked, timeStamp: $timeStamp, date: $date, notificationId: $notificationId, shouldShowNotification: $shouldShowNotification)";
  }
}
