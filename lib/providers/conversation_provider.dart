import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/providers/message_provider.dart';
import 'package:whatsapp_clone/providers/user_auth_provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

Stream<List<Conversation>> _getConversations() {
  return _firestore
      .collection('conversations')
      .where('participants', arrayContains: _auth.currentUser!.uid)
      .orderBy(
        'last_timestamp',
        descending: true,
      )
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Conversation.fromFirestore(doc.id, doc.data());
    }).toList();
  });
}

Future<Message> _getLatestMessage(String messageId) async {
  final message = await _firestore.collection('messages').doc(messageId).get();
  return Message.fromFirestore(message.id, message.data()!);
}

final conversationStreamProvider = StreamProvider<List<Conversation>>((ref) {
  final authState = ref.watch(userAuthProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return _getConversations();
      } else {
        return const Stream.empty();
      }
    },
    loading: () => const Stream.empty(),
    error: (error, stackTrace) => const Stream.empty(),
  );
});

final unreadCounterProvider =
    StreamProvider.family<int, String>((ref, conversationId) {
  final messagesProvider = ref.watch(messageStreamProvider(conversationId));

  return messagesProvider.when(
    data: (messages) {
      final unreadCount = messages
          .where((message) =>
              message.receiverId == _auth.currentUser!.uid &&
              message.status == Status.delivered)
          .toList()
          .length;
      return Stream.value(unreadCount);
    },
    loading: () => Stream.value(0),
    error: (error, stackTrace) => Stream.value(0),
  );
});

final latestMessageProvider =
    FutureProvider.family<Message, String>((ref, messageId) {
  return _getLatestMessage(messageId);
});
