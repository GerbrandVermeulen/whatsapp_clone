import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/chat.dart';
import 'package:whatsapp_clone/model/dummy_data.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/widgets/home/items/archived.dart';
import 'package:whatsapp_clone/widgets/home/items/chat_item.dart';
import 'package:whatsapp_clone/widgets/home/items/search.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key, required this.chats});

  final List<Chat> chats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (chats.isEmpty) {
      return Center(
        child: Text(
          'No chats added yet',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white),
        ),
      );
    }

    Map<String, dynamic> loadedUsers = {};

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('phone_number',
                whereIn: dummy_chats.map((e) => e.number).toList())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Add loaded users as they arrive
            final userData = snapshot.data!.docs;
            loadedUsers = {
              ...loadedUsers,
              for (var user in userData)
                user.data()['phone_number']: user.data(),
            };
          }

          return ListView.builder(
            itemCount: chats.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Search();
              }
              if (index == 1) {
                return const Archived();
              }

              final chat = chats[index - 2];
              final number = chat.number;
              // TODO Cache users locally, but update with json rsp
              final user = User(phoneNumber: number);
              user.updateFromJson(loadedUsers[number]);

              return ChatItem(
                user: user,
                chat: chat,
              );
            },
          );
        });
  }
}
