import 'package:flutter/material.dart';
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/domain/outputs/chat_message_output.dart';
import 'package:moli_ai/presentation/widgets/conversation_widget.dart';

class ChatMessageWidget extends StatefulWidget {
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  final ChatMessageOutput message;

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _userMessageBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.44), _colorScheme.primaryContainer);
  late final _userMessageColor = _colorScheme.onPrimaryContainer;
  late final _aiMessageBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.secondaryContainer);
  late final _aiMessageColor = _colorScheme.onSecondaryContainer;
  late final _sysMessageColor = _colorScheme.onSecondaryContainer;
  @override
  Widget build(BuildContext context) {
    if (widget.message.role == roleUser) {
      return PromptMessageWidget(
        message: widget.message.message,
        role: widget.message.role,
        backgroundColor: _userMessageBackgroundColor,
        messageColor: _userMessageColor,
      );
    } else if (widget.message.role == roleAI) {
      return AiResponseMessageWidget(
        message: widget.message.message,
        role: widget.message.role,
        backgroundColor: _aiMessageBackgroundColor,
        messageColor: _aiMessageColor,
      );
    } else {
      return SysResponseMessageWidget(
        message: widget.message.message,
        role: widget.message.role,
        messageColor: _sysMessageColor,
      );
    }
  }
}
