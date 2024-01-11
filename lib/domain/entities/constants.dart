import 'package:flutter/material.dart';
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';

final ChatEntity defaultChatEntity = ChatEntity(
  id: 0,
  icon: Icons.chat.codePoint,
  title: "随便聊聊",
  convType: "chat",
  desc: "",
  rank: 0,
  prompt: "Hi, how are you?",
  modelName: geminiProModel.modelName,
  lastTime: 0,
);
