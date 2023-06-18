import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/add_event/add_event_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events_v1/events_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/widgets/general/customized_outlined_button.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';
import 'package:reminder/utils/values/theme_values.dart';
import 'package:flutter/cupertino.dart';

typedef OnDateTimeChanged = void Function(DateTime);

class AddEventBottomSheet extends StatelessWidget {
  const AddEventBottomSheet({super.key});

  final spacerHeight = 32.0;

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor =
        BlocProvider.of<ThemeCubit>(context).isDarkTheme()
            ? darkThemeButtonBackgroundColor
            : lightThemeButtonBackgroundColor;

    return BlocConsumer<AddEventBloc, AddEventState>(builder: (context, state) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment,
                children: [
                  TextFormField(
                    initialValue: state.name.isEmpty ? null : state.name,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "Enter event name"),
                    onChanged: (newName) {
                      BlocProvider.of<AddEventBloc>(context)
                          .add(NameChangedEvent(newName));
                    },
                  ),
                  SizedBox(height: spacerHeight),
                  _getRowItem(
                      hint: "Date",
                      value: state.dateTime.toMonthDayYear(),
                      onPressed: () {
                        _showDateTimePicker(
                            context,
                            CupertinoDatePickerMode.date,
                            state.dateTime, (newDateTime) {
                          BlocProvider.of<AddEventBloc>(context)
                              .add(DateChangedEvent(newDateTime));
                        });
                      }),
                  SizedBox(height: spacerHeight),
                  _getRowItem(
                    hint: "Time",
                    value: state.dateTime.toTime(),
                    onPressed: () => _showDateTimePicker(
                        context, CupertinoDatePickerMode.time, state.dateTime,
                        (newDateTime) {
                      BlocProvider.of<AddEventBloc>(context)
                          .add(TimeChangedEvent(newDateTime));
                    }),
                  ),
                  SizedBox(height: spacerHeight),
                  CustomizedOutlinedButton(
                    onPressed: () =>
                        BlocProvider.of<AddEventBloc>(context).add(SaveEvent()),
                    buttonBackgroundColor: buttonBackgroundColor,
                    text: "Save",
                  ),
                  SizedBox(height: spacerHeight)
                ],
              ))
        ],
      );
    }, listener: (context, state) {
      if (state.validationState == ValidationState.success) {
        BlocProvider.of<EventsBloc>(context).add(AddEvent(state.event, () {
          BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
        }));
        Navigator.pop(context);
      } else if (state.validationState == ValidationState.empty) {
        print("Event Name is blank!");
      }
    });
  }

  void _showDateTimePicker(BuildContext context, CupertinoDatePickerMode mode,
      DateTime? initialTime, OnDateTimeChanged onChanged) {
    showModalBottomSheet(
        context: context,
        builder: (_) => CupertinoDatePicker(
            initialDateTime: initialTime,
            mode: mode,
            onDateTimeChanged: onChanged));
  }

  Widget _getRowItem(
      {required String hint,
      required String value,
      required VoidCallback onPressed}) {
    return GestureDetector(
        onTap: onPressed,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(hint, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16))
        ]));
  }
}
