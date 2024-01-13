import 'package:flutter/material.dart';
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/presentation/widgets/conversation_widget.dart';

class ChatMessageWidget extends StatefulWidget {
  const ChatMessageWidget({
    super.key,
    required this.conversation,
  });

  final ChatMessageEntity conversation;

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
