import 'package:flutter/material.dart';
import 'package:moli_ai/utils/color.dart';

import '../constants/constants.dart';
import '../models/conversation_model.dart';
import 'text_widget.dart';

class ConversationMessageWidget extends StatefulWidget {
  const ConversationMessageWidget({
    super.key,
    required this.conversation,
  });

  final ConversationMessageModel conversation;

  @override
  State<ConversationMessageWidget> createState() =>
      _ConversationMessageWidgetState();
}

class _ConversationMessageWidgetState extends State<ConversationMessageWidget> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _userMessageBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.44), _colorScheme.primary);
  late final _userMessageColor = _colorScheme.onPrimary;
  late final _aiMessageBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.secondaryContainer);
  late final _aiMessageColor = _colorScheme.onSecondaryContainer;
  late final _sysMessageColor = _colorScheme.onSecondaryContainer;
  @override
  Widget build(BuildContext context) {
    if (widget.conversation.role == roleUser) {
      return PromptMessageWidget(
        message: widget.conversation.message,
        role: widget.conversation.role,
        backgroundColor: _userMessageBackgroundColor,
        messageColor: _userMessageColor,
      );
    } else if (widget.conversation.role == roleAI) {
      return AiResponseMessageWidget(
        message: widget.conversation.message,
        role: widget.conversation.role,
        backgroundColor: _aiMessageBackgroundColor,
        messageColor: _aiMessageColor,
      );
    } else {
      return SysResponseMessageWidget(
        message: widget.conversation.message,
        role: widget.conversation.role,
        messageColor: _sysMessageColor,
      );
    }
  }
}

class PromptMessageWidget extends StatelessWidget {
  const PromptMessageWidget({
    Key? key,
    required this.message,
    required this.role,
    required this.messageColor,
    required this.backgroundColor,
  }) : super(key: key);

  final String message;
  final String role;
  final Color messageColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
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
                color: getShadowColor(colorScheme),
                spreadRadius: 1.0,
                blurRadius: 6.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: PromptTextMessageWidget(message: message, color: messageColor),
        ),
      ),
    );
  }
}

class AiResponseMessageWidget extends StatelessWidget {
  const AiResponseMessageWidget({
    Key? key,
    required this.message,
    required this.role,
    required this.messageColor,
    required this.backgroundColor,
  }) : super(key: key);

  final String message;
  final String role;
  final Color messageColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 64, top: 10, bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.all(12),
          child: ConversationMessageReplyWidget(
              message: message, color: messageColor),
        ),
      ),
    );
  }
}

class SysResponseMessageWidget extends StatelessWidget {
  const SysResponseMessageWidget({
    Key? key,
    required this.message,
    required this.role,
    required this.messageColor,
  }) : super(key: key);

  final String message;
  final String role;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 2),
      child: Align(
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Expanded(
                child: ConversationMessageReplyWidget(message: '------')),
            Text(message, style: TextStyle(color: messageColor)),
            const Expanded(
                child: ConversationMessageReplyWidget(message: '------')),
          ],
        ),
      ),
    );
  }
}
