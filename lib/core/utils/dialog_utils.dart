import 'package:flutter/material.dart';

class DialogUtils {
  static Future<void> showLoading(
    BuildContext context, {
    String message = "loading",
    bool dismissible = false,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  static Future<void> buildDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? posActionText,
    String? negActionText,
    Function()? posAction,
    Function()? negAction,
    bool dismissible = false,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog(
        content: content != null ? Text(content) : null,
        title: title != null ? Text(title) : null,
        actions: [
          if (negActionText != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (negAction != null) negAction();
              },
              child: Text(negActionText),
            ),
          if (posActionText != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (posAction != null) posAction();
              },
              child: Text(posActionText),
            ),
        ],
      ),
    );
  }
}
