import 'package:flutter/material.dart';

class ChatMessageReplyWidget extends StatelessWidget {
  const ChatMessageReplyWidget({
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
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.message,
    this.fontSize = 18,
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
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
