import 'dart:developer';

import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.sendMessage});

  final void Function(String message) sendMessage;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _emojiShowing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Theme.of(context).colorScheme.surface,
                ),
                margin: const EdgeInsets.only(right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Offstage(
                    //   offstage: !_emojiShowing,
                    //   child: EmojiPicker(
                    //     textEditingController: _controller,
                    //     scrollController: _scrollController,
                    //     config: const Config(
                    //       height: 256,
                    //       checkPlatformCompatibility: true,
                    //       viewOrderConfig: ViewOrderConfig(),
                    //       emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28),
                    //     ),
                    //   ),
                    // ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          _emojiShowing = !_emojiShowing;
                        });
                      },
                      icon: const Icon(Icons.emoji_emotions_outlined),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autocorrect: true,
                        canRequestFocus: true,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filled(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  )),
                  onPressed: () {
                    widget.sendMessage(_controller.text);
                    _controller.clear();
                  },
                  padding: const EdgeInsets.all(14),
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
