import 'package:flutter/material.dart';

Future<void> showNotificationDalog({
  required BuildContext context,
  required String message,
  required List<Widget> actions,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: 24,
          bottom: 24,
          left: 24,
          right: 24,
        ),
        backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        content: Text(
          message,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              ),
        ),
        actions: actions,
      );
    },
  );
}
