import 'dart:developer';

import 'package:moli_ai/domain/dto/palm_text_dto.dart';
import 'package:moli_ai/data/models/error_resp.dart';

class AzureOpenAIChatReqMessageData {
  final String content;
  final String role;

  AzureOpenAIChatReqMessageData({required this.content, required this.role});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['role'] = role;
    return data;
  }
}

class AzureOpenAIMessageReq {
  final String apiVersion;
  final String apiKey;
  final String basicUrl;
  final String modelName;
  final List<AzureOpenAIChatReqMessageData> messages;
  final double temperature;
  final int maxTokens;

  AzureOpenAIMessageReq({
    required this.messages,
    required this.modelName,
    required this.apiKey,
    required this.apiVersion,
    required this.basicUrl,
    required this.temperature,
    required this.maxTokens,
  });
}

class AzureOpenAIChatMessageResp {
  String? id;
  String? object;
  int? created;
  String? model;
  Usage? usage;
  List<Choices>? choices;
  ErrorResp? error;

  AzureOpenAIChatMessageResp(
      {this.id,
      this.object,
      this.created,
      this.model,
      this.usage,
      this.choices,
      this.error});

  factory AzureOpenAIChatMessageResp.fromJson(Map<String, dynamic> json) {
    // List<Choices> choices =
    //     json['choices'].map((e) => Choices.fromJson(e)).toList();
    List<Choices> choices = [];
    if (json.containsKey('choices')) {
      choices =
          List<Choices>.from(json['choices'].map((e) => Choices.fromJson(e)));
    }
    // log("json: $json");
    return AzureOpenAIChatMessageResp(
      id: json['id'] ?? '',
      object: json['object'] ?? '',
      created: json['created'] as int? ?? 0,
      model: json['model'] ?? '',
      choices: choices,
      usage: json['usage'] != null ? Usage.fromJson(json['usage']) : null,
      error:
          json['error'] != null ? ErrorResp.fromAzureJson(json['error']) : null,
    );
  }
}

class Choices {
  Message message;
  String finishReason;
  int index;

  Choices(
      {required this.message, required this.finishReason, required this.index});

  factory Choices.fromJson(Map<String, dynamic> json) {
    return Choices(
        message: Message.fromJson(json['message']),
        finishReason: json['finish_reason'] as String,
        index: json['index'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message.toJson();
    data['finish_reason'] = finishReason;
    data['index'] = index;
    return data;
  }
}

class Message {
  String role;
  String content;

  Message({required this.role, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(role: json['role'], content: json['content']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    return data;
  }
}

class Usage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  Usage(
      {required this.promptTokens,
      required this.completionTokens,
      required this.totalTokens});

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
        promptTokens: json['prompt_tokens'],
        completionTokens: json['completion_tokens'],
        totalTokens: json['total_tokens']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prompt_tokens'] = promptTokens;
    data['completion_tokens'] = completionTokens;
    data['total_tokens'] = totalTokens;
    return data;
  }
}
