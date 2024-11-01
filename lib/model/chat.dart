import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/model/message.dart';

class Chat {
  const Chat({
    required this.unreadCount,
    required this.lastMessage,
    required this.messages,
  });

  final int unreadCount;
  final Message lastMessage;
  final List<Message> messages;
}
