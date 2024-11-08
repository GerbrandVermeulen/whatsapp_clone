import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/providers/message_provider.dart';
import 'package:whatsapp_clone/widgets/chat/message_bubble.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({super.key, required this.conversation});

  final Conversation conversation;

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  void _markMessageAsSeen(String messageId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({
      'status': 'read',
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conversation.isEmpty()) {
      return Container();
    }

    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final messageStream =
        ref.watch(messageStreamProvider(widget.conversation.id));

    return messageStream.when(
      data: (messages) {
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 8,
            left: 8,
            right: 8,
          ),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final chatMessage = messages[index];
            final nextChatMessage =
                index + 1 < messages.length ? messages[index + 1] : null;

            final currentMessageUserId = chatMessage.senderId;
            final nextMessageUserId = nextChatMessage?.senderId;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (chatMessage.status == Status.delivered &&
                authenticatedUser.uid == chatMessage.receiverId) {
              _markMessageAsSeen(messages[index].id);
            }

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessage.message,
                  status: chatMessage.status,
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
            return MessageBubble.first(
                message: chatMessage.message,
                status: chatMessage.status,
                isMe: authenticatedUser.uid == currentMessageUserId);
          },
        );
      },
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
    );
  }
}
