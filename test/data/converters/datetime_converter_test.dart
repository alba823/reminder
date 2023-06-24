import 'package:flutter_test/flutter_test.dart';
import 'package:reminder/data/converters/datetime_converter.dart';

void main() {
  late DateTimeConverter dateTimeConverter;

  setUp(() {
    dateTimeConverter = DateTimeConverter();
  });

  test("decode should return DateTime from int value", () {
    const intValue = 123;
    final expectedValue = DateTime.fromMillisecondsSinceEpoch(intValue);

    final actualValue = dateTimeConverter.decode(intValue);

    expect(actualValue, equals(expectedValue));
  });

  test("encode should return int value from DateTime", () {
    final dateTime = DateTime.now();
    final expectedValue = dateTime.millisecondsSinceEpoch;

    final actualValue = dateTimeConverter.encode(dateTime);

    expect(actualValue, equals(expectedValue));
  });
}