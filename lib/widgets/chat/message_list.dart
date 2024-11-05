import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/providers/message_provider.dart';
import 'package:whatsapp_clone/widgets/chat/message_bubble.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({super.key, required this.conversation});

  final Conversation conversation;

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final messageStream =
        ref.watch(messageStreamProvider(widget.conversation.id));

    return messageStream.when(
      data: (messageData) {
        final loadedMessages = messageData.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 8,
            left: 8,
            right: 8,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['sender_id'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['sender_id'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessage['message'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
            return MessageBubble.first(
                message: chatMessage['message'],
                isMe: authenticatedUser.uid == currentMessageUserId);
          },
        );
      },
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
    );
  }
}
