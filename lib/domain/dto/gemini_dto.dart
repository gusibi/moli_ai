import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/core/utils/time.dart';
import 'package:moli_ai/data/models/gemini_api_message_req.dart';
import 'package:moli_ai/domain/inputs/ai_chat_input.dart';
import 'package:moli_ai/domain/outputs/ai_chat_output.dart';

GeminiApiMessageReq geminiApiMessageReqFromReq(AIChatCompletionInput req) {
  List<GeminiMessageContent> contents = [];
  for (int i = 0; i < req.messages.length; i++) {
    GeminiMessageContent content = GeminiMessageContent(
        parts: [Parts(text: req.messages[i].content)],
        role: req.messages[i].role);
    contents.add(content);
  }
  GeminiApiMessageReq geminiReq = GeminiApiMessageReq(
    modelName: req.model,
    contents: contents,
    generationConfig: GeminiGenerationConfig(
        temperature: 0.7, maxOutputTokens: 4096, topK: 1.0, topP: 1.0),
  );
  return geminiReq;
}

AIChatCompletionOutput geminiRespApiToAIChatCompletionOutput(
    GeminiApiMessageResp resp) {
  if (resp.error != null) {
    List<ChoiceOutput> choices = [
      ChoiceOutput(
          index: 2,
          message: MessageOutput(role: roleSys, content: resp.error!.message),
          finishReason: "sysError")
    ];
    return AIChatCompletionOutput(
        id: "aiError",
        object: "aiError",
        created: timestampNow(),
        model: "",
        systemFingerprint: "aiError",
        choices: choices);
  }
  List<ChoiceOutput> choices = [];
  for (int i = 0; i < resp.candidates!.length; i++) {
    GeminiResCandidate candidate = resp.candidates![i];
    String content = "";
    for (int j = 0; j < candidate.content!.parts.length; j++) {
      content = candidate.content!.parts[j].text!;
    }
    MessageOutput message = MessageOutput(role: roleAI, content: content);
    choices.add(ChoiceOutput(
        index: candidate.index!,
        message: message,
        logprobs: null,
        finishReason: candidate.finishReason!));
  }
  AIChatCompletionOutput output = AIChatCompletionOutput(
      id: "",
      object: "",
      created: timestampNow(),
      model: '',
      systemFingerprint: '',
      choices: choices,
      usage: null);
  return output;
}
