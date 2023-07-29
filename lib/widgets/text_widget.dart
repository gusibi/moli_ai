import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'markdown_view_widget.dart';

class PromptTextMessageWidget extends StatelessWidget {
  const PromptTextMessageWidget({
    Key? key,
    required this.message,
    this.fontSize = 14,
    this.color,
    this.fontWeight,
  }) : super(key: key);

  final String message;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SelectableText(
        message,
        // textAlign: TextAlign.right,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
      onLongPress: () {
        ClipboardData data = ClipboardData(text: message);
        Clipboard.setData(data);
        // Show a snackbar to notify the user that the text has been copied.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text copied to clipboard'),
          ),
        );
      },
    );
  }
}

class ConversationMessageReplyWidget extends StatelessWidget {
  const ConversationMessageReplyWidget({
    Key? key,
    required this.message,
    this.fontSize = 14,
    this.color,
    this.fontWeight,
  }) : super(key: key);

  final String message;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MarkdownView(
        markdown: message,
      ),
      onLongPress: () {
        ClipboardData data = ClipboardData(text: message);
        Clipboard.setData(data);
        // Show a snackbar to notify the user that the text has been copied.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text copied to clipboard'),
          ),
        );
      },
    );
  }
}

// class TextWidget extends StatelessWidget {
//   const TextWidget({
//     Key? key,
//     required this.message,
//     this.fontSize = 18,
//     this.color,
//     this.fontWeight,
//   }) : super(key: key);

//   final String message;
//   final double fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       message,
//       style: TextStyle(
//         color: color ?? Colors.blue,
//         fontSize: fontSize,
//         fontWeight: fontWeight ?? FontWeight.normal,
//       ),
//     );
//   }
// }
