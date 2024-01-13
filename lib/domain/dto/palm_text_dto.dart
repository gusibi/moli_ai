import 'package:moli_ai/data/models/error_resp.dart';
import 'package:moli_ai/data/models/gemini_api_message_req.dart';

class Candidate {
  String? output;
  List<SafetyRating>? safetyRatings;

  Candidate({this.output, this.safetyRatings});

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        output: json['output'] as String?,
        safetyRatings: (json['safetyRatings'] as List<dynamic>?)
            ?.map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'output': output,
        'safetyRatings': safetyRatings?.map((e) => e.toJson()).toList(),
      };
}

class PalmTextMessageResp {
  List<Candidate>? candidates;
  ErrorResp? error;

  PalmTextMessageResp({this.candidates, this.error});

  factory PalmTextMessageResp.fromJson(Map<String, dynamic> json) =>
      PalmTextMessageResp(
        candidates: (json['candidates'] as List<dynamic>?)
            ?.map((e) => Candidate.fromJson(e as Map<String, dynamic>))
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

class PalmTextMessageReq {
  final String prompt;
  final String modelName;
  final String apiKey;
  final String basicUrl;
  final double temperature;
  final int maxOutputTokens;

  PalmTextMessageReq(
      {required this.prompt,
      required this.modelName,
      required this.apiKey,
      required this.basicUrl,
      required this.temperature,
      required this.maxOutputTokens});
}

class PalmChatReqMessageData {
  final String content;
  final String role;

  PalmChatReqMessageData({required this.content, required this.role});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['role'] = role;
    return data;
  }
}

class PalmChatExampleData {
  final PalmChatReqMessageData input;
  final PalmChatReqMessageData output;

  PalmChatExampleData({required this.input, required this.output});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['input'] = input.toJson();
    data['output'] = output.toJson();
    return data;
  }
}

class PalmChatMessageReq {
  final String apiKey;
  final String basicUrl;
  final String modelName;
  String context;
  List<PalmChatExampleData> examples;
  final List<PalmChatReqMessageData> messages;
  final double temperature;
  final int maxOutputTokens;

  PalmChatMessageReq({
    required this.messages,
    required this.modelName,
    required this.apiKey,
    required this.basicUrl,
    required this.temperature,
    required this.maxOutputTokens,
    this.context = "",
    this.examples = const [],
  });
}

class PalmChatMessageResp {
  List<PalmChatRespMessageData>? candidates;
  List<PalmChatRespMessageData>? messages;
  ErrorResp? error;

  PalmChatMessageResp({this.candidates, this.messages, this.error});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['candidates'] = candidates!.map((v) => v.toJson()).toList();
    data['messages'] = messages!.map((v) => v.toJson()).toList();
    return data;
  }

  factory PalmChatMessageResp.fromJson(Map<String, dynamic> json) {
    if (json['candidates'] == null) {
      return PalmChatMessageResp(
          error: ErrorResp(message: "Response is Empty", code: -1, status: ''));
    }
    List<dynamic> candidatesJson = json['candidates'];
    List<PalmChatRespMessageData> candidates =
        candidatesJson.map((e) => PalmChatRespMessageData.fromJson(e)).toList();
    return PalmChatMessageResp(
      candidates: candidates,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((e) => PalmChatRespMessageData.fromJson(e))
              .toList()
          : null,
      error: json['error'] != null ? ErrorResp.fromJson(json['error']) : null,
    );
  }
}

class PalmChatRespMessageData {
  String author;
  String content;

  PalmChatRespMessageData({required this.author, required this.content});

  factory PalmChatRespMessageData.fromJson(Map<String, dynamic> json) =>
      PalmChatRespMessageData(author: json["author"], content: json["content"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['content'] = content;
    return data;
  }
}
