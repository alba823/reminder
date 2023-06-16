import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events_v1/events_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/utils/theme_values.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(builder: (context, state) {
      final items = state.getEventsForDate();
      return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final event = items[index];
            return Dismissible(
                key: Key(event.id.toString()),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) {
                  BlocProvider.of<EventsBloc>(context)
                      .add(DeleteEvent(event, () {
                    BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
                  }));
                },
                background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.redAccent,
                    child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Icon(Icons.delete))),
                secondaryBackground: Container(color: Colors.greenAccent),
                child: Column(
                  children: [
                    EventWidget(
                      name: event.name,
                      isChecked: event.isChecked,
                      onChecked: (isChecked) {
                        BlocProvider.of<EventsBloc>(context)
                            .add(CheckEvent(event, isChecked, () {
                          BlocProvider.of<CalendarBloc>(context)
                              .add(OnUpdate());
                        }));
                      },
                    ),
                    if (index != items.length - 1) const Divider()
                  ],
                ));
          });
    });
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
