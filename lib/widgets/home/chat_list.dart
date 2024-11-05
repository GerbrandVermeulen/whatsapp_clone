import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/chat.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/providers/conversation_provider.dart';
import 'package:whatsapp_clone/providers/message_provider.dart';
import 'package:whatsapp_clone/providers/user_provider.dart';
import 'package:whatsapp_clone/widgets/home/items/archived.dart';
import 'package:whatsapp_clone/widgets/home/items/chat_item.dart';
import 'package:whatsapp_clone/widgets/home/items/search.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationStream = ref.watch(conversationStreamProvider);

    return conversationStream.when(
      data: (conversations) {
        return ListView.builder(
          itemCount: conversations.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Search();
            }
            if (index == 1) {
              return const Archived();
            }

            final conversation = conversations[index - 2];
            final userId = conversation.participants.firstWhere(
              (u) => u != _auth.currentUser!.uid,
            );

            final userFuture = ref.watch(userProvider(userId));

            return userFuture.when(
              data: (user) {
                final latestMessageFuture =
                    ref.watch(latestMessageProvider(conversation.lastMessage));

                return latestMessageFuture.when(
                  data: (lastMessage) {
                    final chat = Chat(
                      unreadCount:
                          // TODO Maybe add unread count to conversations (per user)
                          _auth.currentUser!.uid == lastMessage.senderId
                              ? 0
                              : 1,
                      lastMessage: lastMessage,
                      messages: [lastMessage],
                    );

                    ref.read(messageStreamProvider(conversation.id).future);

                    return ChatItem(
                      user: user,
                      chat: chat,
                      conversation: conversation,
                    );
                  },
                  loading: () => Container(),
                  error: (error, stackTrace) => Container(),
                );
              },
              loading: () => Container(),
              error: (error, stackTrace) => Container(),
            );
          },
        );
      },
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
    );
  }
}
