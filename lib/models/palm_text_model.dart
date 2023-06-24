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

class TextModel {
  List<Candidate>? candidates;

  TextModel({this.candidates});

  factory TextModel.fromJson(Map<String, dynamic> json) => TextModel(
        candidates: (json['candidates'] as List<dynamic>?)
            ?.map((e) => Candidate.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'candidates': candidates?.map((e) => e.toJson()).toList(),
      };
}

class PalmMessageModel {
  final String msg;
  final String chatRole;

  PalmMessageModel({required this.msg, required this.chatRole});
}
