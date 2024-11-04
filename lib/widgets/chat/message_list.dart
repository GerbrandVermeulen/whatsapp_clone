import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/widgets/chat/message_bubble.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('conversation_id', isEqualTo: widget.conversation.id)
          .orderBy(
            'timestamp_sent',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final loadedMessages = snapshot.data!.docs;

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
    );
  }
}
