import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:moli_ai/data/models/error_resp.dart';
import 'package:moli_ai/data/models/gemini_api_message_req.dart';
import 'package:moli_ai/domain/inputs/ai_config_input.dart';

import '../../core/constants/constants.dart';

class GeminiApiService {
  final AIApiConfigInput apiConfig;

  GeminiApiService({required this.apiConfig});

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
      log("URL: $url");
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(url));
      var body = json.encode({
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
      request.body = body;
      log("request: $body");
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

  Future<GeminiApiMessageResp> generateContent(GeminiApiMessageReq req) async {
    var currentModel = req.modelName;
    var baseURL = apiConfig.basicUrl;
    var apiKey = apiConfig.apiKey;
    try {
      // log("start, model: $currentModel, prompt: $prompt");
      var url = "$baseURL/models/$currentModel:generateContent?key=$apiKey";
      log("URL: $url");
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(url));
      var body = json.encode({
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
      request.body = body;
      log("request: $body");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 400) {
        var resp = await response.stream.bytesToString();
        log("resp $resp");
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
}
