import 'package:moli_ai/constants/constants.dart';

import '../models/conversation_model.dart';
import 'azure_openai_dto.dart';
import 'palm_text_dto.dart';

class ChatMessageData {
  final String content;
  final String role;

  ChatMessageData({required this.content, required this.role});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['role'] = role;
    return data;
  }
}

class TextAIMessageReq {
  final String aiService;
  final String prompt;
  final String modelName;
  final String apiKey;
  final String basicUrl;
  final double temperature;
  final int maxOutputTokens;
  final List<ChatMessageData> messages;
  String apiVersion;

  TextAIMessageReq(
      {required this.prompt,
      required this.messages,
      required this.modelName,
      required this.aiService,
      required this.apiKey,
      this.apiVersion = "",
      required this.basicUrl,
      required this.temperature,
      required this.maxOutputTokens});

  PalmTextMessageReq toPalmReq() {
    final palmReq = PalmTextMessageReq(
        prompt: prompt,
        modelName: modelName,
        apiKey: apiKey,
        basicUrl: basicUrl,
        temperature: temperature,
        maxOutputTokens: maxOutputTokens);
    return palmReq;
  }

  AzureOpenAIMessageReq toAzureReq() {
    List<AzureOpenAIChatReqMessageData> ms = messages.map((m) {
      var role = m.role;
      if (role == roleAI) {
        role = roleAssistant;
      }
      return AzureOpenAIChatReqMessageData(content: m.content, role: role);
    }).toList();
    final azureReq = AzureOpenAIMessageReq(
      apiKey: apiKey,
      basicUrl: basicUrl,
      modelName: modelName,
      apiVersion: apiVersion,
      temperature: temperature,
      maxTokens: maxOutputTokens,
      messages: ms,
    );
    return azureReq;
  }
}

class ChatAIMessageReq {
  final String aiService;
  final String apiKey;
  final String basicUrl;
  final String modelName;
  String prompt;
  List<ConversationMessageModel> examples;
  final List<ConversationMessageModel> messages;
  final double temperature;
  final int maxOutputTokens;

  ChatAIMessageReq({
    required this.aiService,
    required this.messages,
    required this.modelName,
    required this.apiKey,
    required this.basicUrl,
    required this.temperature,
    required this.maxOutputTokens,
    this.prompt = "",
    this.examples = const [],
  });
}

class MessageCandidate {
  Message? message;
  String? finishReason;
  int? index;
  List<SafetyRating>? safetyRatings;

  MessageCandidate(
      {this.message, this.finishReason, this.index, this.safetyRatings});

  factory MessageCandidate.fromJson(Map<String, dynamic> json) =>
      MessageCandidate(
        message: Message(content: json['message'], role: roleAI),
        safetyRatings: (json['safetyRatings'] as List<dynamic>?)
            ?.map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'safetyRatings': safetyRatings?.map((e) => e.toJson()).toList(),
      };
}

class TextMessageResp {
  String? id;
  String? object;
  int? created;
  String? model;
  Usage? usage;
  List<MessageCandidate>? candidates;
  ErrorResp? error;

  TextMessageResp(
      {this.id,
      this.object,
      this.created,
      this.model,
      this.usage,
      this.candidates,
      this.error});

  factory TextMessageResp.fromPalmResp(PalmTextMessageResp resp) {
    List<MessageCandidate>? choices = resp.candidates?.map((e) {
      return MessageCandidate(
        message: Message(content: e.output!, role: roleAI),
      );
    }).toList();
    return TextMessageResp(
      candidates: choices,
      error: resp.error,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'object': object,
        'created': created,
        'model': model,
        'usage': usage?.toJson(),
        'candidates': candidates?.map((e) => e.toJson()).toList(),
        'error': error?.toJson(),
      };

  factory TextMessageResp.fromAzureResp(AzureOpenAIChatMessageResp resp) {
    List<MessageCandidate>? choices = resp.choices?.map((e) {
      var role = roleAI;
      if (e.message.role == "assistant") {
        role = roleAI;
      } else {
        role = roleSys;
      }
      return MessageCandidate(
        message: Message(role: role, content: e.message.content),
        finishReason: e.finishReason,
        index: e.index,
      );
    }).toList();
    return TextMessageResp(
      id: resp.id,
      object: resp.object,
      created: resp.created,
      model: resp.model,
      candidates: choices,
      error: resp.error,
    );
  }
}
