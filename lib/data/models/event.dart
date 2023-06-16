import 'package:floor/floor.dart';
import 'package:reminder/utils/date_time_extensions.dart';

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

  Event(this.id, this.name, this.isChecked, this.timeStamp, this.date);

  factory Event.optional(
          {int? id,
          required String name,
          bool? isChecked,
          DateTime? timeStamp,
          String? date}) =>
      Event(
          id,
          name,
          isChecked ?? false,
          timeStamp ?? DateTime.now(),
          date ??
              timeStamp?.convertToYearDay() ??
              DateTime.now().convertToYearDay());

  Event copyWith(
      {String? name, bool? isChecked, DateTime? timeStamp, String? date}) {
    return Event.optional(
        id: id,
        name: name ?? this.name,
        isChecked: isChecked ?? this.isChecked,
        timeStamp: timeStamp ?? this.timeStamp,
        date: date ?? this.date);
  }

  @override
  String toString() {
    return "Event(id: $id, name: $name, isCheked: $isChecked, timeStamp: $timeStamp)";
  }
}
