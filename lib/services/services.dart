import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:moli_ai/constants/api_constants.dart';
import 'package:moli_ai/dto/ai_service_dto.dart';
import 'package:moli_ai/services/azure_openai_service.dart';

import '../constants/constants.dart';
import '../dto/palm_text_dto.dart';
import 'palm_api_service.dart';

class AIApiService {
  static List<String> getModels() {
    try {
      return modelsList;
    } catch (error) {
      log("error, $error");
      throw HttpException("$error");
    }
  }

  static Future<TextMessageResp> getTextReponse(TextAIMessageReq req) async {
    if (req.aiService == PALM_SERVICE) {
      var palmReq = req.toPalmReq();
      var resp = await PalmApiService.getTextReponse(palmReq);
      return TextMessageResp.fromPalmResp(resp);
    } else if (req.aiService == AZURE_SERVICE) {
      var azureReq = req.toAzureReq();
      var resp = await AzureOpenAIApiService.getChatReponse(azureReq);
      return TextMessageResp.fromAzureResp(resp);
    } else {
      return TextMessageResp(
          error: ErrorResp(
              code: -1,
              message: "[Bad Request] api service not support",
              status: "400"));
    }
  }

  static Future<PalmChatMessageResp> getChatReponse(
      PalmChatMessageReq req) async {
    var currentModel = req.modelName;
    var baseURL = req.basicUrl;
    var apiKey = req.apiKey;
    var context = req.context;
    try {
      // log("start, model: $currentModel, prompt: $context");
      log("$baseURL/models/$currentModel:generateMessage?key=$apiKey");
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              "$baseURL/models/$currentModel:generateMessage?key=$apiKey"));
      request.body = json.encode({
        "prompt": {
          "context": context,
          "examples": req.examples,
          "messages": req.messages
        },
        "temperature": req.temperature,
        "top_k": 40,
        "top_p": 0.95,
        "candidate_count": 1
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 400) {
        var resp = await response.stream.bytesToString();
        // log("resp $resp");
        Map<String, dynamic> jsonResponse = jsonDecode(resp);
        // log("jsonResponse $jsonResponse");
        return PalmChatMessageResp.fromJson(jsonResponse);
      } else {
        return PalmChatMessageResp(
            error: ErrorResp(code: -1, message: "Bad Request", status: ""));
      }
    } catch (error) {
      log("catch error, $error");
      return PalmChatMessageResp(
          error: ErrorResp(code: -1, message: error.toString(), status: ""));
    }
  }
}
