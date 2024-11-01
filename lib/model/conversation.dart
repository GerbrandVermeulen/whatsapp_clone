import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.lastMessage,
    required this.lastTimestamp,
    required this.participants,
  });

  Conversation.fromFirestore(this.id, dynamic conversation)
      : lastMessage = conversation['last_message'],
        lastTimestamp = (conversation['last_timestamp'] as Timestamp).toDate(),
        participants = List<String>.from(conversation['participants']);

  final String id;
  final String lastMessage;
  final DateTime lastTimestamp;
  final List<String> participants;
}
