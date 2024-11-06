import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/widgets/chat/last_seen.dart';
import 'package:whatsapp_clone/widgets/chat/message_list.dart';
import 'package:whatsapp_clone/widgets/chat/new_message.dart';
import 'package:whatsapp_clone/widgets/home/profile_icon.dart';

auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.user,
    required this.conversation,
  });

  final User user;
  Conversation conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // TODO Notifications
  late Conversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  void _sendMessage(String message) async {
    Timestamp now = Timestamp.now();
    Conversation conversation = _conversation;

    final messageDoc =
        await FirebaseFirestore.instance.collection('messages').add({
      'message': message,
      'receiver_id': widget.user.id,
      'sender_id': _auth.currentUser!.uid,
      'status': 'delivered',
      'timestamp_sent': now,
      'type': 'text',
    });

    if (conversation.isEmpty()) {
      final conversationDoc =
          await FirebaseFirestore.instance.collection('conversations').add({
        'last_message': messageDoc.id,
        'last_timestamp': now,
        'participants': [widget.user.id, _auth.currentUser!.uid],
      });
      conversation = Conversation(
        id: conversationDoc.id,
        lastMessage: messageDoc.id,
        lastTimestamp: now.toDate(),
        participants: [widget.user.id, _auth.currentUser!.uid],
      );
    } else {
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversation.id)
          .update({
        'last_message': messageDoc.id,
        'last_timestamp': now,
      });
      conversation.lastMessage = messageDoc.id;
      conversation.lastTimestamp = now.toDate();
    }

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageDoc.id)
        .update({
      'conversation_id': conversation.id,
    });
    setState(() {
      _conversation = conversation;
    });
  }

  void _deleteChat() async {
    if (_conversation != null) {
      final messages = await FirebaseFirestore.instance
          .collection('messages')
          .where('conversation_id', isEqualTo: _conversation!.id)
          .get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(_conversation!.id)
          .delete();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  ProfileIcon(user: widget.user, radius: 16),
                ],
              ),
            ),
          ],
        ),
        leadingWidth: 80,
        titleSpacing: 0,
        title: SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.displayName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                if (widget.user.lastSeen != null)
                  LastSeen(lastSeen: widget.user.lastSeen!),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
          ),
          PopupMenuButton(
            offset: const Offset(0, 54),
            color: Colors.white,
            onSelected: (value) {
              if (value == 0) {
                _deleteChat();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Delete chat'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/default_background.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.7),
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: MessageList(
                conversation: _conversation,
              )),
              NewMessage(
                sendMessage: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
