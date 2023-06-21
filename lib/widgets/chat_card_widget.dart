import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/chat_list_model.dart';

class ChatCardWidget extends StatefulWidget {
  const ChatCardWidget({
    super.key,
    required this.chatInfo,
    this.isPreview = true,
    this.index = 0,
    this.id = 0,
    this.onSelected,
  });

  final int index;
  final ChatCardModel chatInfo;
  final int id;
  final bool isPreview;
  final void Function()? onSelected;

  @override
  State<ChatCardWidget> createState() => _ChatCardWidgetState();
}

class _ChatCardWidgetState extends State<ChatCardWidget> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.38),
    _colorScheme.surface,
  );
  bool _isSelected = false;

  Color get _surfaceColor {
    if (_isSelected) return _colorScheme.primaryContainer;
    // if (!widget.isPreview) return _colorScheme.surface;
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
          shadowColor: Colors.white,
          color: _surfaceColor,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatCardHeadline(
                  index: widget.index,
                  chatInfo: widget.chatInfo,
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
    required this.chatInfo,
    required this.isSelected,
  });

  final ChatCardModel chatInfo;
  final bool isSelected;
  final int index;

  @override
  State<ChatCardHeadline> createState() => _ChatCardHeadlineState();
}

class _ChatCardHeadlineState extends State<ChatCardHeadline> {
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.38),
    _colorScheme.onSurface,
  );

  Color get _onSurfaceColor {
    if (widget.isSelected) return _colorScheme.onPrimaryContainer;
    return unselectedColor;
  }

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
              CircleAvatar(child: Icon(widget.chatInfo.icon)),
              const Padding(padding: EdgeInsets.only(right: 8.0)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatInfo.title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: _onSurfaceColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.chatInfo.prompt.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: _onSurfaceColor,
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
                    color: _onSurfaceColor,
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
