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
  List<ChoiceOutput> choices;
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
        choices: List<ChoiceOutput>.from(
            json["choices"].map((x) => ChoiceOutput.fromJson(x))),
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

class ChoiceOutput {
  int index;
  MessageOutput message;
  dynamic logprobs;
  String finishReason;

  ChoiceOutput({
    required this.index,
    required this.message,
    required this.finishReason,
    this.logprobs,
  });

  factory ChoiceOutput.fromJson(Map<String, dynamic> json) => ChoiceOutput(
        index: json["index"],
        message: MessageOutput.fromJson(json["message"]),
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

class MessageOutput {
  String role;
  String content;

  MessageOutput({
    required this.role,
    required this.content,
  });

  factory MessageOutput.fromJson(Map<String, dynamic> json) => MessageOutput(
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
