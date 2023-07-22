import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/utils/values/theme_values.dart';

class CustomizedCheckBox extends StatelessWidget {
  const CustomizedCheckBox({
    super.key,
    required this.isChecked,
    required this.onChecked,
  });

  final bool isChecked;
  final Function(bool) onChecked;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (v) => onChecked(v ?? false),
      shape: const CircleBorder(),
      checkColor: _getCheckColor(context),
    );
  }

  Color _getCheckColor(BuildContext context) {
    if (BlocProvider.of<ThemeCubit>(context).isDarkTheme()) {
      return darkThemeColor;
    } else {
      return lightThemeColor;
    }
  }
}
