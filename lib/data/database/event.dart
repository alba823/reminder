import 'package:floor/floor.dart';

@Entity(tableName: "events", indices: [
  Index(value: ['id'], unique: true)
])
class Event {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isChecked;
  final DateTime timeStamp;

  Event(this.id, this.name, this.isChecked, this.timeStamp);

  factory Event.optional(
          {int? id,
          required String name,
          bool? isChecked,
          DateTime? timeStamp}) =>
      Event(id, name, isChecked ?? false, timeStamp ?? DateTime.now());

  Event copyWith({String? name, bool? isChecked, DateTime? timeStamp}) {
    return Event.optional(
        id: id,
        name: name ?? this.name,
        isChecked: isChecked ?? this.isChecked,
        timeStamp: timeStamp ?? this.timeStamp);
  }

  @override
  String toString() {
    return "Event(id: $id, name: $name, isCheked: $isChecked, timeStamp: $timeStamp)";
  }
}
