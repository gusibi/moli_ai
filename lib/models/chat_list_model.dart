import 'package:flutter/material.dart';

class ChatCardModel {
  final String title;
  final IconData? icon;
  final String? prompt;
  final String? modelName;

  ChatCardModel(
      {required this.icon,
      required this.title,
      required this.prompt,
      required this.modelName});
}
