import 'package:flutter/material.dart';

class Archived extends StatelessWidget {
  const Archived({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: const Color.fromARGB(35, 255, 235, 59),
      visualDensity: const VisualDensity(vertical: -4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: const Icon(Icons.archive_outlined),
      ),
      title: Text(
        'Archived',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
