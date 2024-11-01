import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.id,
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.type,
    required this.status,
    required this.timestampSent,
  });

  Message.fromFirestore(this.id, Map<String, dynamic> message)
      : message = message['message'],
        receiverId = message['receiver_id'],
        senderId = message['sender_id'],
        type = message['type'],
        status = Status.convertStrToEnum(message['status']),
        timestampSent = (message['timestamp_sent'] as Timestamp).toDate();

  final String id;
  final String message;
  final String receiverId;
  final String senderId;
  final String type;
  final Status status;
  final DateTime timestampSent;
}

enum Status {
  received,
  sending,
  sent,
  delivered,
  read,
  failed;

  static Status convertStrToEnum(String val) {
    switch (val) {
      case 'received':
        return Status.received;
      case 'sending':
        return Status.sending;
      case 'sent':
        return Status.sent;
      case 'delivered':
        return Status.delivered;
      case 'read':
        return Status.read;
      case 'failed':
        return Status.failed;
      default:
        return Status.failed;
    }
  }
}
