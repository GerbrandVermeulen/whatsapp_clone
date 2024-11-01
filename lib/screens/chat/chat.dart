import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/widgets/chat/last_seen.dart';
import 'package:whatsapp_clone/widgets/chat/new_message.dart';
import 'package:whatsapp_clone/widgets/home/profile_icon.dart';

auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.user,
    this.conversation,
  });

  final User user;
  Conversation? conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // TODO Notifications
  Conversation? _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  void _sendMessage(String message) async {
    Timestamp now = Timestamp.now();
    final messageDoc =
        await FirebaseFirestore.instance.collection('messages').add({
      'message': message,
      'receiver_id': widget.user.id,
      'sender_id': _auth.currentUser!.uid,
      'status': 'delivered',
      'timestamp_sent': now,
      'type': 'text',
    });

    if (_conversation != null) {
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(_conversation!.id)
          .update({
        'last_message': messageDoc.id,
        'last_timestamp': now,
      });
      _conversation = Conversation(
        id: _conversation!.id,
        lastMessage: messageDoc.id,
        lastTimestamp: now.toDate(),
        participants: [widget.user.id, _auth.currentUser!.uid],
      );
      return;
    }

    final conversationDoc =
        await FirebaseFirestore.instance.collection('conversations').add({
      'last_message': messageDoc.id,
      'last_timestamp': now,
      'participants': [widget.user.id, _auth.currentUser!.uid],
    });
    _conversation = Conversation(
      id: conversationDoc.id,
      lastMessage: messageDoc.id,
      lastTimestamp: now.toDate(),
      participants: [widget.user.id, _auth.currentUser!.uid],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('New group'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          NewMessage(
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
