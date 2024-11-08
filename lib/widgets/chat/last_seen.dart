import 'package:flutter/material.dart';
import 'package:whatsapp_clone/util/date_time_formatter.dart';

class LastSeen extends StatelessWidget {
  const LastSeen({
    super.key,
    required this.lastSeen,
  });

  final DateTime lastSeen;

  String _formatLastSeen() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (lastSeen.isAfter(now.subtract(const Duration(seconds: 30)))) {
      return 'online';
    }
    if (lastSeen.isBefore(yesterday)) {
      return 'last seen ${DateTimeFormatter.formatDate(lastSeen)} at ${DateTimeFormatter.formatTime(lastSeen)}';
    }
    if (lastSeen.isBefore(today)) {
      return 'last seen yesterday at ${DateTimeFormatter.formatTime(lastSeen)}';
    }
    return 'last seen today at ${DateTimeFormatter.formatTime(lastSeen)}';
  }

  @override
  Widget build(BuildContext context) {
    final lastSeenFormatted = _formatLastSeen();
    return Text(
      lastSeenFormatted,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          overflow: TextOverflow.ellipsis),
    );
  }
}
