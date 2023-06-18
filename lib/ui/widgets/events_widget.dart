import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/add_event/add_event_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events_v1/events_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/ui/screens/add_event_bottom_sheet.dart';
import 'package:reminder/ui/widgets/general/customized_outlined_button.dart';
import 'package:reminder/utils/values/theme_values.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.buttonBackgroundColor});

  final Color buttonBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(builder: (context, state) {
      final items = state.getEventsForDate();
      if (items.isEmpty) {
        return Center(child: _getAddEventButton(context));
      } else {
        return _getEventsList(context, items);
      }
    });
  }

  Widget _getEventsList(BuildContext context, List<Event> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final event = items[index];
          return Column(
            children: [
              Dismissible(
                  key: Key(event.id.toString()),
                  onDismissed: (_) {
                    BlocProvider.of<EventsBloc>(context)
                        .add(DeleteEvent(event, () {
                      BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
                    }));
                  },
                  dismissThresholds: const {
                    DismissDirection.startToEnd: 0.6,
                    DismissDirection.endToStart: 0.2,
                  },
                  confirmDismiss: (direction) async =>
                      direction == DismissDirection.startToEnd,
                  background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.redAccent,
                      child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(Icons.delete))),
                  secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.greenAccent,
                      child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(Icons.edit))),
                  child: EventWidget(
                    name: event.name,
                    isChecked: event.isChecked,
                    onChecked: (isChecked) {
                      BlocProvider.of<EventsBloc>(context)
                          .add(CheckEvent(event, isChecked, () {
                        BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
                      }));
                    },
                  )),
              if (index != items.length - 1)
                const Divider(height: 0.1)
              else
                _getAddEventButton(context)
            ],
          );
        });
  }

  Widget _getAddEventButton(BuildContext context) {
    return CustomizedOutlinedButton(
        onPressed: () => showModalBottomSheet<dynamic>(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BlocProvider(
                  create: (_) => AddEventBloc(
                      event: Event.optional(
                          name: "",
                          timeStamp: BlocProvider.of<CalendarBloc>(context)
                              .state
                              .selectedDay
                      )
                  ),
                  child: const AddEventBottomSheet());
            }),
        buttonBackgroundColor: buttonBackgroundColor,
        icon: Icons.add);
  }
}

class EventWidget extends StatelessWidget {
  const EventWidget(
      {super.key,
      required this.name,
      required this.isChecked,
      required this.onChecked});

  final String name;
  final bool isChecked;
  final Function(bool) onChecked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 12, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Checkbox(
            value: isChecked,
            onChanged: (v) => onChecked(v ?? false),
            shape: const CircleBorder(),
            checkColor: _getCheckColor(context),
          )
        ],
      ),
    );
  }

  Color _getCheckColor(BuildContext context) {
    if (context.watch<ThemeCubit>().isDarkTheme()) {
      return darkThemeColor;
    } else {
      return lightThemeColor;
    }
  }
}
