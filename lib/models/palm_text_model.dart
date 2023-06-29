import 'dart:ffi';

class SafetyRating {
  String? category;
  String? probability;

  SafetyRating({this.category, this.probability});

  factory SafetyRating.fromJson(Map<String, dynamic> json) => SafetyRating(
        category: json['category'] as String?,
        probability: json['probability'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'probability': probability,
      };
}

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

  PalmChatReqMessageData({required this.content});
}

class PalmChatExampleData {
  final PalmChatReqMessageData input;
  final PalmChatReqMessageData output;

  PalmChatExampleData({required this.input, required this.output});
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
    return PalmChatMessageResp(
      candidates: json['candidates'],
      messages: json['messages'],
      error: json['error'],
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

class ErrorResp {
  final int code;
  final String message;
  final String status;

  ErrorResp({required this.code, required this.message, required this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    return data;
  }

  factory ErrorResp.fromJson(Map<String, dynamic> json) {
    return ErrorResp(
      code: json['code'] as int,
      message: json['message'] as String,
      status: json['status'] as String,
    );
  }
}
