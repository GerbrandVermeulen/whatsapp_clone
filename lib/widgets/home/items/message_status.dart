import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/message.dart';

class MessageStatus extends StatelessWidget {
  const MessageStatus({
    super.key,
    required this.status,
    this.size = 18,
  });

  final Status status;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget? indicator;

    switch (status) {
      case Status.sending:
        indicator = Icon(
          Icons.access_time_outlined,
          size: size,
        );

      case Status.sent:
        indicator = Icon(
          Icons.done_rounded,
          size: size,
        );

      case Status.delivered:
        indicator = Icon(
          Icons.done_all_rounded,
          color: Colors.grey,
          size: size,
        );

      case Status.read:
        indicator = Icon(
          Icons.done_all_rounded,
          color: Colors.lightBlue,
          size: size,
        );

      case Status.failed:
        indicator = Icon(
          Icons.cancel_outlined,
          color: Colors.redAccent,
          size: size,
        );

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
