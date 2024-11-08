import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/util/date_time_formatter.dart';
import 'package:whatsapp_clone/widgets/home/items/message_status.dart';

// A MessageBubble for showing a single chat message on the ChatScreen.
class MessageBubble extends StatelessWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  const MessageBubble.first({
    super.key,
    required this.message,
    required this.timeSent,
    required this.status,
    required this.isMe,
  }) : isFirstInSequence = true;

  // Create a amessage bubble that continues the sequence.
  const MessageBubble.next({
    super.key,
    required this.message,
    required this.timeSent,
    required this.status,
    required this.isMe,
  }) : isFirstInSequence = false;

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;
  final String message;
  final DateTime timeSent;
  final Status status;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Row(
          // The side of the chat screen the message should show at.
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // The "speech" box surrounding the message.
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isMe
                            ? theme.colorScheme.secondary
                            : Colors.grey[200],
                        // Only show the message bubble's "speaking edge" if first in
                        // the chain.
                        // Whether the "speaking edge" is on the left or right depends
                        // on whether or not the message bubble is the current user.
                        borderRadius: BorderRadius.only(
                          topLeft: !isMe && isFirstInSequence
                              ? Radius.zero
                              : const Radius.circular(12),
                          topRight: isMe && isFirstInSequence
                              ? Radius.zero
                              : const Radius.circular(12),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        ),
                      ),
                      // Set some reasonable constraints on the width of the
                      // message bubble so it can adjust to the amount of text
                      // it should show.
                      constraints: const BoxConstraints(
                        minWidth: 75,
                        maxWidth: 200,
                      ),
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 10,
                        bottom: 12,
                        right: 20,
                      ),
                      // Margin around the bubble.
                      margin: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              message,
                              style: TextStyle(
                                // Add a little line spacing to make the text look nicer
                                // when multilined.
                                height: 1.3,
                                color: isMe
                                    ? theme.colorScheme.onSecondary
                                    : Colors.black87,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 3,
                      child: Row(
                        children: [
                          Text(
                            DateTimeFormatter.formatTime(timeSent),
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe
                                  ? theme.colorScheme.onSecondary.withAlpha(105)
                                  : Colors.black38,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          if (!isMe)
                            const SizedBox(
                              width: 4,
                            ),
                          if (isMe)
                            MessageStatus(
                              status: status,
                              size: 15,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
