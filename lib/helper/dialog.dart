import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(message)));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey[800],
              strokeWidth: 1.5,
            ),
          );
        });
  }
}
