import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/chat.dart';
import 'package:whatsapp_clone/model/conversation.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/providers/conversation_provider.dart';
import 'package:whatsapp_clone/screens/chat/chat.dart';
import 'package:whatsapp_clone/widgets/home/items/message_status.dart';
import 'package:whatsapp_clone/widgets/home/profile_icon.dart';

auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

class ChatItem extends ConsumerWidget {
  const ChatItem({
    super.key,
    required this.user,
    required this.chat,
    required this.conversation,
  });

  final User user;
  final Chat chat;
  final Conversation conversation;

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestMessage = chat.lastMessage;

    final isToday = _isSameDay(latestMessage.timestampSent, DateTime.now());

    final year = latestMessage.timestampSent.year.toString();
    final month = latestMessage.timestampSent.month.toString().padLeft(2, '0');
    final day = latestMessage.timestampSent.day.toString().padLeft(2, '0');

    final hours = latestMessage.timestampSent.hour.toString().padLeft(2, '0');
    final minutes =
        latestMessage.timestampSent.minute.toString().padLeft(2, '0');

    final messageStatus = _auth.currentUser!.uid == latestMessage.senderId
        ? latestMessage.status
        : Status.received;

    final unreadCounter = ref.watch(unreadCounterProvider(conversation.id));

    return ListTile(
      leading: ProfileIcon(
        user: user,
        radius: 24,
      ),
      title: Text(
        user.displayName,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Row(
        children: [
          MessageStatus(
            status: messageStatus,
          ),
          Expanded(
            child: Text(
              chat.messages.isNotEmpty
                  ? latestMessage.message
                  : '[no messages yet]',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    overflow: TextOverflow.fade,
                  ),
              softWrap: false,
            ),
          ),
        ],
      ),
      trailing: unreadCounter.when(
        data: (unreadCount) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chat.messages.isNotEmpty
                  ? isToday
                      ? '$hours:$minutes'
                      : '$year/$month/$day'
                  : '',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: unreadCount > 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            unreadCount > 0
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '$unreadCount',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                    ),
                  )
                : const SizedBox(height: 20),
          ],
        ),
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatScreen(
            user: user,
            conversation: conversation,
          ),
        ));
      },
    );
  }
}
