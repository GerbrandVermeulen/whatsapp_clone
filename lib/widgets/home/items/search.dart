import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          color: const Color.fromARGB(49, 158, 158, 158),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/meta-ai.png'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ask Mate AI or Search',
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
