import 'package:flutter/material.dart';

void showInSnackBar(context, String value,
    {color = Colors.green, bool onError = false}) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: onError ? Colors.red : color,
        content: Row(
          children: [
            Icon(
              color: Colors.white,
              onError
                  ? Icons.report_problem_outlined
                  : Icons.check_circle_outline_rounded,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        )));
  } catch (e) {
    debugPrint('error from snack bar ');
  }
}
