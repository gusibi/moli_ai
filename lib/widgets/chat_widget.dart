import 'package:flutter/material.dart';
import 'package:moli_ai_box/services/assets_manager.dart';

import '../constants/constants.dart';
import 'text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.message,
    required this.chatIndex,
  }) : super(key: key);

  final String message;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset(
                chatIndex == 0
                    ? AssetsManager.userImage
                    : AssetsManager.palmLogo,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 15),
              Expanded(child: ChatMessageWidget(message: message)),
              chatIndex == 0
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.thumb_down_alt_outlined,
                            color: Colors.white),
                      ],
                    ),
            ]),
          )),
    ]);
  }
}
