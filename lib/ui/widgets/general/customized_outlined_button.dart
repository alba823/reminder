import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomizedOutlinedButton extends StatelessWidget {
  const CustomizedOutlinedButton(
      {super.key,
      required this.onPressed,
      required this.buttonBackgroundColor,
      this.icon,
      this.text});

  final VoidCallback onPressed;
  final Color buttonBackgroundColor;
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final Widget childWidget;
    if (icon != null) {
      childWidget = Icon(icon);
    } else if (text != null) {
      childWidget = Text(text!);
    } else {
      childWidget = Text(AppLocalizations.of(context)!.undefinedButtonText);
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
          backgroundColor: MaterialStatePropertyAll(buttonBackgroundColor)),
      child: childWidget,
    );
  }
}