import 'package:flutter/material.dart';

import '../models/conversation_model.dart';

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

final ConversationModel defaultConversation = ConversationModel(
  id: 0,
  icon: Icons.chat.codePoint,
  title: "随便聊聊",
  desc: "",
  rank: 0,
  prompt: "Hi, how are you?",
  modelName: "text-bison-001",
  lastTime: 0,
);

final ConversationModel newConversation = ConversationModel(
  id: 0,
  icon: Icons.chat.codePoint,
  title: "New Chat",
  desc: "",
  rank: 0,
  prompt: "You can setting yourself prompt",
  modelName: "text-bison-001",
  lastTime: 0,
);

const String palmConfigname = "palmConfig";
