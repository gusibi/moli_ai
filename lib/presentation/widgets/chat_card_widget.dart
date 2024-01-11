import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';

import '../../data/models/conversation_model.dart';
import '../../core/utils/color.dart';
import '../../core/utils/icon.dart';

class ChatCardWidget extends StatefulWidget {
  const ChatCardWidget({
    super.key,
    required this.chatEntity,
    this.isPreview = true,
    this.index = 0,
    this.id = 0,
    this.onSelected,
  });

  final int index;
  final ChatEntity chatEntity;
  final int id;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<ChatCardWidget> createState() => _ChatCardWidgetState();
}

class _ChatCardWidgetState extends State<ChatCardWidget> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.08),
    _colorScheme.surface,
  );
  late final Color selectedColor = _colorScheme.surfaceTint;

  bool _isSelected = false;

  Color get _cardColor {
    if (_isSelected) return _colorScheme.primaryContainer;
    return unselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) {
        setState(() {
          _isSelected = true;
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          _isSelected = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onSelected,
        child: Card(
          elevation: 4,
          shadowColor: getShadowColor(_colorScheme),
          color: _cardColor,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatCardHeadline(
                  index: widget.index,
                  conversation: widget.chatEntity,
                  isSelected: _isSelected)
            ],
          ),
        ),
      ),
    );
  }
}

class ChatCardHeadline extends StatefulWidget {
  const ChatCardHeadline({
    super.key,
    required this.index,
    required this.conversation,
    required this.isSelected,
  });

  final ChatEntity conversation;
  final bool isSelected;
  final int index;

  @override
  State<ChatCardHeadline> createState() => _ChatCardHeadlineState();
}

class _ChatCardHeadlineState extends State<ChatCardHeadline> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 84,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  child: Icon(convertCodeToIconData(widget.conversation.icon))),
              const Padding(padding: EdgeInsets.only(right: 8.0)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.conversation.title,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.conversation.modelName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Text(
                      widget.conversation.desc.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              // Display a "condensed" version if the widget in the row are
              // expected to overflow.
              if (constraints.maxWidth - 200 > 0) ...[
                const Padding(padding: EdgeInsets.only(right: 8.0)),
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    // color: _onSurfaceColor,
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    });
  }
}
