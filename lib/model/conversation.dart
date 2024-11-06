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

  Conversation.empty()
      : id = '-1',
        lastMessage = '',
        lastTimestamp = DateTime.now(),
        participants = List.empty();

  bool isEmpty() {
    return id == '-1';
  }

  final String id;
  String lastMessage;
  DateTime lastTimestamp;
  final List<String> participants;
}
