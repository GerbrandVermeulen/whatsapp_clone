import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/chat.dart';

class MessageStatus extends StatelessWidget {
  const MessageStatus({super.key, required this.status});

  final Status status;

  @override
  Widget build(BuildContext context) {
    Widget? indicator;

    switch (status) {
      case Status.sending:
        indicator = const Icon(
          Icons.access_time_outlined,
          size: 8,
        );

      case Status.sent:
        indicator = const Icon(Icons.done_rounded);

      case Status.delivered:
        indicator = const Icon(
          Icons.done_all_rounded,
          color: Colors.grey,
          size: 18,
        );

      case Status.read:
        indicator = const Icon(
          Icons.done_all_rounded,
          color: Colors.lightBlue,
          size: 18,
        );

      case Status.failed:
        indicator = const Icon(Icons.cancel_outlined, color: Colors.redAccent);

      case Status.received:
        indicator = null;
    }

    return indicator == null
        ? Container()
        : Row(
            children: [
              indicator,
              const SizedBox(
                width: 8,
              ),
            ],
          );
  }
}
