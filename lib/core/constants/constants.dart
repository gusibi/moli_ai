import 'package:flutter/material.dart';

import '../../data/models/conversation_model.dart';

List<String> modelsList = [
  "chat-bison-001",
  "text-bison-001",
  "gemini-pro",
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

final ChatModel defaultConversation = ChatModel(
  id: 0,
  icon: Icons.chat.codePoint,
  title: "随便聊聊",
  convType: "chat",
  desc: "",
  rank: 0,
  prompt: "Hi, how are you?",
  modelName: "text-bison-001",
  lastTime: 0,
);

final ChatModel newConversation = ChatModel(
  id: 0,
  icon: Icons.chat.codePoint,
  title: "New Chat",
  convType: "chat",
  desc: "",
  rank: 0,
  prompt: "You can setting yourself prompt",
  modelName: "text-bison-001",
  lastTime: 0,
);

final ChatModel newDiaryConversation = ChatModel(
  id: 0,
  icon: Icons.note.codePoint,
  title: "Today Diary",
  convType: "diary",
  desc: "you can talk with ai",
  rank: 0,
  prompt: "You can setting yourself prompt",
  modelName: textModel.modelName,
  lastTime: 0,
);

const String palmConfigname = "palmConfig";
const String azureConfigname = "azureConfig";
const String themeConfigname = "themeConfig";
const String defaultAIConfigname = "defaultAIConfig";
const String roleUser = "user";
const String roleAI = "ai";
const String roleAssistant = "assistant";
const String roleSys = "system";
const String roleContext = "context";

const maxInt = 9223372036854775807;
const queyMessageLimit = 100;

class PalmModel {
  final String modelName;
  final String modelDesc;

  PalmModel({required this.modelName, required this.modelDesc});
}

final PalmModel geminiProModel = PalmModel(
    modelName: "gemini-pro",
    modelDesc:
        """Gemini is a family of generative AI models that lets developers generate content and solve problems. 
        These models are designed and trained to handle both text and images as input. 
        This guide provides information about each model variant to help you decide which is the best fit for your use case.""");

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

enum PalmModels { textModel, chatModel, geminiProModel }

final Map<PalmModels, String> palmModelsMap = {
  PalmModels.textModel: textModel.modelName,
  PalmModels.chatModel: chatModel.modelName,
  PalmModels.geminiProModel: geminiProModel.modelName,
};

const String diaryPrompt = '''
Hello, I want you to be my daily journal co-pilot. I will write down my random thoughts, notes ideas etc during the day. At the end of the day I will ask you to:
1. Write a version of my journal that is better formatted, logically structured/organized, with improved writing without altering the meaning of my journal.
2. Summarize the key take-aways from my journal
3. Discover important insights into my life
4. Base on my journal, create an actionable to-do lists of the tasks/plans mentioned in my journal. Write the list in first-person voice, also in JSON following this template: 
{
"Task Name ": "Task Description",
}

please using the following format: 

## Improved Journal Entry

here is imporoved journal entry

## Key Takeaways

here is key takeways

## Insights

here is insights

## Actionable To-Do List

here is to-do list, must return json format, example {
    "Develop AI Tutoring System": "I need to start developing my idea for a learning tutor system using ChatGPT.",
    "Invest in Tesla": "I need to review my investment plan for Tesla and decide whether to adjust it based on the recent market movement."
}

Here is my thoughts: {%s}

Thanks!
''';

final PalmModel azureGPT35Model = PalmModel(
    modelName: "GPT35", modelDesc: """Generates text in a conversational format.
Optimized for dialog language tasks such as implementation of chat bots or AI agents.
Can handle zero, one, and few-shot tasks.""");

enum AzureModels { azureGPT35Model }

final Map<AzureModels, String> azureModelsMap = {
  AzureModels.azureGPT35Model: azureGPT35Model.modelName,
};
