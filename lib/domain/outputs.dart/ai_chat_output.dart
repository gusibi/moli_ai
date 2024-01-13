// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AIChatCompletionOutput aiChatCompletionOutputFromJson(String str) =>
    AIChatCompletionOutput.fromJson(json.decode(str));

String aiChatCompletionOutputToJson(AIChatCompletionOutput data) =>
    json.encode(data.toJson());

class AIChatCompletionOutput {
  String id;
  String object;
  int created;
  String model;
  String systemFingerprint;
  List<Choice> choices;
  Usage? usage;

  AIChatCompletionOutput({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.systemFingerprint,
    required this.choices,
    this.usage,
  });

  factory AIChatCompletionOutput.fromJson(Map<String, dynamic> json) =>
      AIChatCompletionOutput(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        systemFingerprint: json["system_fingerprint"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        usage: Usage.fromJson(json["usage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "system_fingerprint": systemFingerprint,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
        "usage": usage!.toJson(),
      };
}

class Choice {
  int index;
  Message message;
  dynamic logprobs;
  String finishReason;

  Choice({
    required this.index,
    required this.message,
    required this.logprobs,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        index: json["index"],
        message: Message.fromJson(json["message"]),
        logprobs: json["logprobs"],
        finishReason: json["finish_reason"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "message": message.toJson(),
        "logprobs": logprobs,
        "finish_reason": finishReason,
      };
}

class Message {
  String role;
  String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}

class Usage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
      );

  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
      };
}
