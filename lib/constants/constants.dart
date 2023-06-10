import 'package:flutter/material.dart';

import '../widgets/text_widget.dart';

Color scaffoldBackgroundColor = Colors.blueGrey;
Color cardColor = const Color(0xFF444654);

List<String> modelsList = [
  "chat-bison-001",
  "text-bison-001",
];

List<DropdownMenuItem<String>>? get getModelsItem {
  List<DropdownMenuItem<String>>? items =
      List<DropdownMenuItem<String>>.generate(
          modelsList.length,
          (index) => DropdownMenuItem(
                value: modelsList[index],
                child: TextWidget(
                  message: modelsList[index],
                  fontSize: 15,
                ),
              ));
  return items;
}

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

String BASE_URL = "https://generativelanguage.googleapis.com/v1beta2";
String API_KEY = "YOUR API KEY";
