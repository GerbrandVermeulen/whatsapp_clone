import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/chat.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/widgets/home/items/archived.dart';
import 'package:whatsapp_clone/widgets/home/items/chat_item.dart';
import 'package:whatsapp_clone/widgets/home/items/search.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

class ChatList extends ConsumerWidget {
  const ChatList({super.key, required this.chats});

  final List<Chat> chats;

  Stream<List<Conversation>> _getConversations() {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: _auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Conversation.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  Future<User> _getUser(String userId) async {
    final user = await _firestore.collection('users').doc(userId).get();
    return User.fromFirestore(user.id, user.data()!);
  }

  Future<Message> _getLatestMessage(String messageId) async {
    final message =
        await _firestore.collection('messages').doc(messageId).get();
    return Message.fromFirestore(message.id, message.data()!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: _getConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (!snapshot.hasData) {
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
          }

          final conversations = snapshot.data!;

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
              return FutureBuilder(
                future: _getUser(userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  // TODO Cache users locally, but update with json rsp
                  final user = snapshot.data!;

                  return FutureBuilder(
                      future: _getLatestMessage(conversation.lastMessage),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        final lastMessage = snapshot.data!;
                        final chat = Chat(
                          unreadCount: 1,
                          lastMessage: lastMessage,
                          messages: [lastMessage],
                        );

                        return ChatItem(
                          user: user,
                          chat: chat,
                          conversation: conversation,
                        );
                      });
                },
              );
            },
          );
        });
  }
}
