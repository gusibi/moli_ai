import 'package:flutter/material.dart';

class ChatCardModel {
  int id;
  String title;
  IconData? icon;
  String? prompt;
  String? modelName;

  ChatCardModel(
      {required this.id,
      required this.icon,
      required this.title,
      required this.prompt,
      required this.modelName});
}
