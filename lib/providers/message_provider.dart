import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/message.dart';

Stream<QuerySnapshot<Map<String, dynamic>>> _getMessages(
    String conversationId) {
  log('Fetching messages for conversation: $conversationId');
  return FirebaseFirestore.instance
      .collection('messages')
      .where('conversation_id', isEqualTo: conversationId)
      .orderBy(
        'timestamp_sent',
        descending: true,
      )
      .snapshots();
}

final messageStreamProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, conversationId) {
  return _getMessages(conversationId);
});
