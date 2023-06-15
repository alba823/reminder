import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/events/events_cubit.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/utils/theme_values.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsCubit = BlocProvider.of<EventsCubit>(context);

    return StreamBuilder(
        stream: eventsCubit.eventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                      key: Key(item.id.toString()),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (_) {
                        eventsCubit.deleteEvent(event: item);
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
                            name: item.name,
                            isChecked: item.isChecked,
                            onChecked: (isChecked) {
                              eventsCubit.checkEvent(item, isChecked);
                            },
                          ),
                          if (index != items.length - 1) const Divider()
                        ],
                      ));
                });
          } else {
            return const Text("Empty");
          }
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