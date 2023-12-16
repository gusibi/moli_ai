import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:moli_ai/dto/palm_text_dto.dart';

class GeminiApiMessageReq {
  final String prompt;
  final String apiKey;
  final String basicUrl;
  final String modelName;
  final List<GeminiMessageContent> contents;
  final GeminiGenerationConfig generationConfig;
  List<SafetySetting>? safetySettings;

  GeminiApiMessageReq({
    required this.prompt,
    required this.contents,
    required this.modelName,
    required this.apiKey,
    required this.basicUrl,
    required this.generationConfig,
  });
}

class Parts {
  String? text;
  InlineData? inlineData;

  Parts({this.text, this.inlineData});

  Parts.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    inlineData = json['inline_data'] != null
        ? InlineData.fromJson(json['inline_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (inlineData != null) {
      data['inline_data'] = inlineData!.toJson();
    }
    return data;
  }
}

class InlineData {
  String? mimeType;
  String? data;

  InlineData({this.mimeType, this.data});

  InlineData.fromJson(Map<String, dynamic> json) {
    mimeType = json['mime_type'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mime_type'] = mimeType;
    data['data'] = this.data;
    return data;
  }
}

class GeminiMessageContent {
  final List<Parts> parts;
  final String role;

  GeminiMessageContent({required this.parts, required this.role});

  factory GeminiMessageContent.fromJson(Map<String, dynamic> json) {
    List<Parts> parts = <Parts>[];
    if (json['parts'] != null) {
      json['parts'].forEach((v) {
        parts.add(Parts.fromJson(v));
      });
    }
    return GeminiMessageContent(parts: parts, role: json['role']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parts'] = parts;
    data['role'] = role;
    return data;
  }
}

class GeminiGenerationConfig {
  final double temperature;
  final double topK;
  final double topP;
  final int maxOutputTokens;

  GeminiGenerationConfig(
      {required this.temperature,
      required this.topK,
      required this.topP,
      required this.maxOutputTokens});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topK'] = topK;
    data['topP'] = topP;
    data['temperature'] = temperature;
    data['maxOutputTokens'] = maxOutputTokens;
    return data;
  }
}

class SafetySetting {
  String? category;
  String? threshold;

  SafetySetting({this.category, this.threshold});

  factory SafetySetting.fromJson(Map<String, dynamic> json) => SafetySetting(
        category: json['category'] as String?,
        threshold: json['threshold'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'threshold': threshold,
      };
}

class GeminiResCandidate {
  GeminiMessageContent? content;
  List<SafetyRating>? safetyRatings;
  String? finishReason;
  int? index;

  GeminiResCandidate(
      {this.content, this.safetyRatings, this.finishReason, this.index});

  factory GeminiResCandidate.fromJson(Map<String, dynamic> json) =>
      GeminiResCandidate(
        content: json['content'] != null
            ? GeminiMessageContent.fromJson(
                json['content'] as Map<String, dynamic>)
            : null,
        safetyRatings: (json['safetyRatings'] as List<dynamic>?)
            ?.map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
            .toList(),
        finishReason: json['finishReason'],
        index: json['index'],
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'safetyRatings': safetyRatings?.map((e) => e.toJson()).toList(),
      };
}

class GeminiApiMessageResp {
  List<GeminiResCandidate>? candidates;
  ErrorResp? error;

  GeminiApiMessageResp({this.candidates, this.error});

  factory GeminiApiMessageResp.fromJson(Map<String, dynamic> json) =>
      GeminiApiMessageResp(
        candidates: (json['candidates'] as List<dynamic>?)
            ?.map((e) => GeminiResCandidate.fromJson(e as Map<String, dynamic>))
            .toList(),
        error: json['error'] == null
            ? null
            : ErrorResp.fromJson(json['error'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'candidates': candidates?.map((e) => e.toJson()).toList(),
        'error': error?.toJson(),
      };
}
