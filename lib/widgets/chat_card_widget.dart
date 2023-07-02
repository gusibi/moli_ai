import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/conversation_model.dart';
import '../utils/color.dart';
import '../utils/icon.dart';

class ConversationCardWidget extends StatefulWidget {
  const ConversationCardWidget({
    super.key,
    required this.conversation,
    this.isPreview = true,
    this.index = 0,
    this.id = 0,
    this.onSelected,
  });

  final int index;
  final ConversationModel conversation;
  final int id;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<ConversationCardWidget> createState() => _ConversationCardWidgetState();
}

class _ConversationCardWidgetState extends State<ConversationCardWidget> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late final Color unselectedColor = _colorScheme.surfaceTint;
  late final Color selectedColor = _colorScheme.surfaceTint;

  bool _isSelected = false;

  Color get _surfaceColor {
    if (_isSelected) return unselectedColor;
    return _colorScheme.surface;
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
          color: _surfaceColor,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConversationCardHeadline(
                  index: widget.index,
                  conversation: widget.conversation,
                  isSelected: _isSelected)
            ],
          ),
        ),
      ),
    );
  }
}

class ConversationCardHeadline extends StatefulWidget {
  const ConversationCardHeadline({
    super.key,
    required this.index,
    required this.conversation,
    required this.isSelected,
  });

  final ConversationModel conversation;
  final bool isSelected;
  final int index;

  @override
  State<ConversationCardHeadline> createState() =>
      _ConversationCardHeadlineState();
}

class _ConversationCardHeadlineState extends State<ConversationCardHeadline> {
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
                    Text(
                      widget.conversation.title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          // color: _onSurfaceColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.conversation.desc.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          // color: _onSurfaceColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              // Display a "condensed" version if the widget in the row are
              // expected to overflow.
              if (constraints.maxWidth - 200 > 0) ...[
                const Padding(padding: EdgeInsets.only(right: 8.0)),
                SizedBox(
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
