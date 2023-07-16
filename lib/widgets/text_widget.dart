import 'package:flutter/material.dart';

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
    return Text(
      message,
      // textAlign: TextAlign.right,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
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
    return MarkdownView(
      markdown: message,
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
