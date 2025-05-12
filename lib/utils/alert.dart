import 'package:flutter/material.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

class Alert {

  static void show(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 3),
        Color backgroundColor = const Color(0xFF3E269F),
        Color textColor = Colors.black,
        TextStyle? textStyle,
      }) {
    floatingSnackBar(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle ??  TextStyle(color: Colors.white),
      duration: duration,
    );
  }
}
