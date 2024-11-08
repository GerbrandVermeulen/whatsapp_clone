import 'package:whatsapp_clone/model/message.dart';

class Chat {
  const Chat({
    required this.lastMessage,
    required this.messages,
  });

  final Message lastMessage;
  final List<Message> messages;
}
