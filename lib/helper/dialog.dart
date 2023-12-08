import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/main.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String message) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(20),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Center(
              child: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ))));
    } catch (e) {
      log('something happened on $e');
    }
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

  static void showFullScreenImage(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            color: Colors.black,
            constraints: BoxConstraints(
              maxHeight: mq.height,
            ),
            child: Tooltip(
              message: 'swipe 2 finger to close',
              
              showDuration: const Duration(seconds: 2),
              child: Center(
                child: InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 0.01,
                  boundaryMargin: const EdgeInsets.symmetric(vertical: 10),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
