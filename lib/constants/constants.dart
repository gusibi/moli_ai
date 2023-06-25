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
const String roleUser = "user";
const String roleAI = "ai";
const String roleSys = "system";

const maxInt = 9223372036854775807;
const queyMessageLimit = 100;

class PalmModel {
  final String modelName;
  final String modelDesc;

  PalmModel({required this.modelName, required this.modelDesc});
}

final PalmModel textModel =
    PalmModel(modelName: "text-bison-001", modelDesc: """Generates text.
Optimized for language tasks such as:
Code generation
Text generation
Text editing
Problem solving
Recommendations generation
Information extraction
Data extraction or generation
AI agent
Can handle zero, one, and few-shot tasks.""");

final PalmModel chatModel = PalmModel(
    modelName: "chat-bison-001",
    modelDesc: """Generates text in a conversational format.
Optimized for dialog language tasks such as implementation of chat bots or AI agents.
Can handle zero, one, and few-shot tasks.""");

enum PalmModels { textModel, chatModel }

final Map<PalmModels, String> palmModelsMap = {
  PalmModels.textModel: textModel.modelName,
  PalmModels.chatModel: chatModel.modelName,
};
