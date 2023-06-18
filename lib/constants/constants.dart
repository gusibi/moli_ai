import 'package:flutter/material.dart';

import '../models/chat_list_model.dart';
import '../widgets/text_widget.dart';

Color scaffoldBackgroundColor = Colors.blueGrey;

List<String> modelsList = [
  "chat-bison-001",
  "text-bison-001",
];

final testChatMessages = [
  {
    "message": "hello, guys",
    "chatIndex": 0,
  },
  {
    "message": "hi, how are you",
    "chatIndex": 1,
  },
  {
    "message": "I'm fine, and you?",
    "chatIndex": 0,
  },
  {
    "message":
        "Sorry, but I can't. I don't have a physical body. I'm a large language model, also known as a conversational AI or chatbot. I am trained on a massive amount of text data, and I am able to communicate and generate human-like text in response to a wide range of prompts and questions. For example, I can provide summaries of factual topics or create stories.",
    "chatIndex": 1,
  },
];

final ChatCardModel defaultChat = ChatCardModel(
  id: 0,
  icon: Icons.chat,
  title: "随便聊聊",
  prompt: "Hi, how are you?",
  modelName: "text-bison-001",
);
