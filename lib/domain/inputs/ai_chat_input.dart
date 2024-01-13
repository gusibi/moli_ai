// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:moli_ai/domain/entities/conversation_entity.dart';

AIChatCompletionInput aiChatCompletionInputFromJson(String str) =>
    AIChatCompletionInput.fromJson(json.decode(str));

String aiChatCompletionInputToJson(AIChatCompletionInput data) =>
    json.encode(data.toJson());

class AIChatCompletionInput {
  String model;
  List<AIChatCompletionMessage> messages;

  AIChatCompletionInput({
    required this.model,
    required this.messages,
  });

  factory AIChatCompletionInput.fromJson(Map<String, dynamic> json) =>
      AIChatCompletionInput(
        model: json["model"],
        messages: List<AIChatCompletionMessage>.from(
            json["messages"].map((x) => AIChatCompletionMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class AIChatCompletionMessage {
  String role;
  String content;

  AIChatCompletionMessage({
    required this.role,
    required this.content,
  });

  factory AIChatCompletionMessage.fromJson(Map<String, dynamic> json) =>
      AIChatCompletionMessage(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}
