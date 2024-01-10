import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:http/http.dart" as http;

import '../../core/constants/constants.dart';
import '../dto/palm_text_dto.dart';

class PalmApiService {
  static List<String> getModels() {
    try {
      return modelsList;
    } catch (error) {
      log("error, $error");
      throw HttpException("$error");
    }
  }

  static Future<PalmTextMessageResp> getTextReponse(
      PalmTextMessageReq req) async {
    var currentModel = req.modelName;
    var baseURL = req.basicUrl;
    var apiKey = req.apiKey;
    var prompt = req.prompt;
    try {
      // log("start, model: $currentModel, prompt: $prompt");
      log("$baseURL/models/$currentModel:generateText?key=$apiKey");
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse("$baseURL/models/$currentModel:generateText?key=$apiKey"));
      request.body = json.encode({
        "prompt": {"text": prompt},
        "temperature": req.temperature,
        "top_k": 40,
        "top_p": 0.95,
        "candidate_count": 1,
        "max_output_tokens": req.maxOutputTokens,
        "stop_sequences": [],
        "safety_settings": [
          {"category": "HARM_CATEGORY_DEROGATORY", "threshold": 1},
          {"category": "HARM_CATEGORY_TOXICITY", "threshold": 1},
          {"category": "HARM_CATEGORY_VIOLENCE", "threshold": 2},
          {"category": "HARM_CATEGORY_SEXUAL", "threshold": 2},
          {"category": "HARM_CATEGORY_MEDICAL", "threshold": 2},
          {"category": "HARM_CATEGORY_DANGEROUS", "threshold": 2}
        ]
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 400) {
        var resp = await response.stream.bytesToString();
        // log("resp $resp");
        Map<String, dynamic> jsonResponse = jsonDecode(resp);
        // log("jsonResponse $jsonResponse");
        return PalmTextMessageResp.fromJson(jsonResponse);
      } else {
        int httpCode = response.statusCode;
        String message = response.reasonPhrase!;
        return PalmTextMessageResp(
            error: ErrorResp(
                code: -1,
                message: "[Bad Request]: $httpCode - $message",
                status: ""));
      }
    } catch (error) {
      log("catch error, $error");
      return PalmTextMessageResp(
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
