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

    if (lastSeen.isBefore(yesterday)) {
      return '${lastSeen.year}/${lastSeen.month}/${lastSeen.day} at ${lastSeen.hour}:${lastSeen.minute}';
    }
    if (lastSeen.isBefore(today)) {
      return 'yesterday at ${lastSeen.hour}:${lastSeen.minute}';
    }
    return 'today at ${lastSeen.hour}:${lastSeen.minute}';
  }

  @override
  Widget build(BuildContext context) {
    final lastSeenFormatted = _formatLastSeen();
    return Text(
      'last seen $lastSeenFormatted',
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          overflow: TextOverflow.ellipsis),
    );
  }
}
