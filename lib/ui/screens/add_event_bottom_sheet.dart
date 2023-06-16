import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/ui/widgets/general/customized_outlined_button.dart';
import 'package:reminder/utils/values/theme_values.dart';

class AddEventBottomSheet extends StatelessWidget {
  const AddEventBottomSheet({super.key, this.event});

  final Event? event;
  final spacerHeight = 32.0;

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor =
        BlocProvider.of<ThemeCubit>(context).isDarkTheme()
            ? darkThemeButtonBackgroundColor
            : lightThemeButtonBackgroundColor;
    final initialDateTime = DateTime.now();

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment,
              children: [
                TextFormField(
                  initialValue: event?.name,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Enter event name"),
                ),
                SizedBox(height: spacerHeight),
                _getRowItem(
                    hint: "Date", value: initialDateTime, onPressed: () {}),
                SizedBox(height: spacerHeight),
                _getRowItem(
                    hint: "Time", value: initialDateTime, onPressed: () {}),
                SizedBox(height: spacerHeight),
                CustomizedOutlinedButton(
                  onPressed: () {},
                  buttonBackgroundColor: buttonBackgroundColor,
                  text: "Save",
                ),
                SizedBox(height: spacerHeight)
              ],
            ))
      ],
    );
  }

  Widget _getRowItem(
      {required String hint,
      required DateTime value,
      required VoidCallback onPressed}) {
    return GestureDetector(
        onTap: onPressed,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(hint), Text(value.toString())]));
  }
}
