import 'package:moli_ai/data/models/google_gemini_model.dart';
import 'package:moli_ai/domain/dto/gemini_dto.dart';
import 'package:moli_ai/data/models/gemini_api_message_req.dart';
import 'package:moli_ai/data/services/gemini_api.service.dart';
import 'package:moli_ai/domain/inputs/ai_chat_input.dart';
import 'package:moli_ai/domain/outputs.dart/ai_chat_output.dart';
import 'package:moli_ai/domain/repositories/ai_chat_repo.dart';

AiChatRepository newGoogleGeminiRepoImpl(GeminiApiConfig config) =>
    GoogleGeminiRepoImpl(GeminiApiService(apiConfig: config));

class GoogleGeminiRepoImpl implements AiChatRepository {
  final GeminiApiService _geminApi;

  GoogleGeminiRepoImpl(this._geminApi);

  @override
  Future<AIChatCompletionOutput> completion(AIChatCompletionInput input) async {
    GeminiApiMessageReq req = geminiApiMessageReqFromGeminiReq(input);
    final geminiResponse = await _geminApi.generateContent(req);
    return geminiRespApiToAIChatCompletionOutput(geminiResponse);
  }
}
