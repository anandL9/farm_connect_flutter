import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

bool isDarkMode() {
  var brightness = SchedulerBinding.instance!.window.platformBrightness;
  return brightness == Brightness.dark;
}

void showAlertDialog(
    {required BuildContext context,
    required String message,
    required void Function() onTap}) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Text('Alert!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                TextButton(onPressed: onTap, child: const Text('OK'))
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

void showSnackBar({required BuildContext context, String message = ''}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 3),
    elevation: 10,
    content: Text(message.toString()),
  ));
}

void showAlertDialogNew(
    {required BuildContext context,
    required String message,
    required void Function() onTap}) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Text('Alert!'),
              content: Text(message),
              actions: [TextButton(onPressed: onTap, child: const Text('OK'))],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}
