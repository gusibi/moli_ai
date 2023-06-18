import 'package:flutter/material.dart';

import '../models/palm_text_model.dart';
import 'text_widget.dart';

class ChatMessageWidget extends StatefulWidget {
  const ChatMessageWidget({
    super.key,
    required this.chatInfo,
  });

  final TextChatModel chatInfo;

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _userMessageBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.44), _colorScheme.primary);
  late final _userMessageColor = _colorScheme.onPrimary;
  late final _aiMessageBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.secondary);
  late final _aiMessageColor = _colorScheme.onSecondary;
  @override
  Widget build(BuildContext context) {
    return widget.chatInfo.chatIndex == 0
        ? ChatPromptWidget(
            message: widget.chatInfo.msg,
            chatIndex: widget.chatInfo.chatIndex,
            backgroundColor: _userMessageBackgroundColor,
            messageColor: _userMessageColor,
          )
        : ChatAiResponseWidget(
            message: widget.chatInfo.msg,
            chatIndex: widget.chatInfo.chatIndex,
            backgroundColor: _aiMessageBackgroundColor,
            messageColor: _aiMessageColor,
          );
  }
}

class ChatPromptWidget extends StatelessWidget {
  const ChatPromptWidget({
    Key? key,
    required this.message,
    required this.chatIndex,
    required this.messageColor,
    required this.backgroundColor,
  }) : super(key: key);

  final String message;
  final int chatIndex;
  final Color messageColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 64, right: 14, top: 10, bottom: 2),
      child: Align(
        alignment: Alignment.topRight,
        // padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1.0,
                blurRadius: 6.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: ChatMessageReplyWidget(message: message, color: messageColor),
        ),
      ),
    );
  }
}

class ChatAiResponseWidget extends StatelessWidget {
  const ChatAiResponseWidget({
    Key? key,
    required this.message,
    required this.chatIndex,
    required this.messageColor,
    required this.backgroundColor,
  }) : super(key: key);

  final String message;
  final int chatIndex;
  final Color messageColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 64, top: 10, bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        // padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.all(12),
          child: ChatMessageReplyWidget(message: message, color: messageColor),
        ),
      ),
    );
  }
}
