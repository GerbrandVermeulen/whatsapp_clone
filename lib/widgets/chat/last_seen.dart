import 'package:flutter/material.dart';

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
      return 'last seen ${_formatDate(lastSeen)} at ${_formatTime(lastSeen)}';
    }
    if (lastSeen.isBefore(today)) {
      return 'last seen yesterday at ${_formatTime(lastSeen)}';
    }
    return 'last seen today at ${_formatTime(lastSeen)}';
  }

  String _formatDate(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
