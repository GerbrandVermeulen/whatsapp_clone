import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/chat.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/widgets/home/items/message_status.dart';
import 'package:whatsapp_clone/widgets/home/profile_icon.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.user,
    required this.chat,
  });

  final User user;
  final Chat chat;

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final latestMessage = chat.messages[0];

    final isToday = _isSameDay(latestMessage.dateTime, DateTime.now());

    final year = latestMessage.dateTime.year.toString();
    final month = latestMessage.dateTime.month.toString().padLeft(2, '0');
    final day = latestMessage.dateTime.day.toString().padLeft(2, '0');

    final hours = latestMessage.dateTime.hour.toString().padLeft(2, '0');
    final minutes = latestMessage.dateTime.minute.toString().padLeft(2, '0');

    return ListTile(
      leading: ProfileIcon(user: user),
      title: Text(
        chat.name,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Row(
        children: [
          MessageStatus(status: latestMessage.status),
          Expanded(
            child: Text(
              chat.messages.isNotEmpty
                  ? latestMessage.text
                  : '[no messages yet]',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    overflow: TextOverflow.fade,
                  ),
              softWrap: false,
            ),
          ),
        ],
      ),
      trailing: Column(
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
                  color: chat.unreadCount > 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(
            height: 4,
          ),
          chat.unreadCount > 0
              ? CircleAvatar(
                  radius: 10,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    chat.unreadCount.toString(),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                  ),
                )
              : const SizedBox(
                  height: 20,
                ),
        ],
      ),
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => chatsDetailsScreen(
        //     place: chats[index],
        //   ),
        // ));
      },
    );
  }
}
