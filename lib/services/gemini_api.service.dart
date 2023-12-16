import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:moli_ai/dto/gemini_dto.dart';

import '../constants/constants.dart';
import '../dto/palm_text_dto.dart';

class GeminiApiService {
  static List<String> getModels() {
    try {
      return modelsList;
    } catch (error) {
      log("error, $error");
      throw HttpException("$error");
    }
  }

  static Future<GeminiApiMessageResp> getTextReponse(
      GeminiApiMessageReq req) async {
    var currentModel = req.modelName;
    var baseURL = req.basicUrl;
    var apiKey = req.apiKey;
    try {
      // log("start, model: $currentModel, prompt: $prompt");
      var url = "$baseURL/models/$currentModel:generateContent?key=$apiKey";
      log(url);
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(url));
      request.body = json.encode({
        "contents": req.contents,
        "generationConfig": {
          "temperature": req.generationConfig.temperature,
          "topK": req.generationConfig.topK,
          "topP": req.generationConfig.topP,
          "maxOutputTokens": req.generationConfig.maxOutputTokens,
          "stop_sequences": [],
        },
        "safety_settings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      });
      // log("request: $request.body");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 400) {
        var resp = await response.stream.bytesToString();
        // log("resp $resp");
        Map<String, dynamic> jsonResponse = jsonDecode(resp);
        // log(jsonEncode(jsonResponse));
        return GeminiApiMessageResp.fromJson(jsonResponse);
      } else {
        int httpCode = response.statusCode;
        String message = response.reasonPhrase!;
        return GeminiApiMessageResp(
            error: ErrorResp(
                code: -1,
                message: "[Bad Request]: $httpCode - $message",
                status: ""));
      }
    } catch (error) {
      log("catch error, $error");
      return GeminiApiMessageResp(
          error: ErrorResp(code: -1, message: error.toString(), status: ""));
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
