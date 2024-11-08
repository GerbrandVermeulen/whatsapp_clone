import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/message.dart';

Stream<List<Message>> _getMessages(String conversationId) {
  log('Fetching messages for conversation: $conversationId');
  return FirebaseFirestore.instance
      .collection('messages')
      .where('conversation_id', isEqualTo: conversationId)
      .orderBy(
        'timestamp_sent',
        descending: true,
      )
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Message.fromFirestore(doc.id, doc.data());
    }).toList();
  });
}

final messageStreamProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
  return _getMessages(conversationId);
});
