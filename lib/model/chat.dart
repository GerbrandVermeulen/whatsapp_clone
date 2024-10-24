class Chat {
  const Chat({
    required this.name,
    required this.number,
    required this.imageUrl,
    required this.unreadCount,
    required this.messages,
  });

  final String name;
  final String number;
  final String imageUrl;
  final int unreadCount;
  final List<Message> messages;
}

enum Status {
  received,
  sending,
  sent,
  delivered,
  read,
  failed,
}

class Message {
  const Message({
    required this.text,
    required this.status,
    required this.dateTime,
  });

  final String text;
  final Status status;
  final DateTime dateTime;
}
