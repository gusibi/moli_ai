import '../models/conversation_model.dart';

class TextAIMessageReq {
  final String aiService;
  final String prompt;
  final String modelName;
  final String apiKey;
  final String basicUrl;
  final double temperature;
  final int maxOutputTokens;

  TextAIMessageReq(
      {required this.prompt,
      required this.modelName,
      required this.aiService,
      required this.apiKey,
      required this.basicUrl,
      required this.temperature,
      required this.maxOutputTokens});
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
