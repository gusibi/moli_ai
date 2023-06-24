import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/palm_text_model.dart';
import '../providers/palm_priovider.dart';

class PalmApiService {
  static List<String> getModels() {
    try {
      return modelsList;
    } catch (error) {
      log("error, $error");
      throw HttpException("$error");
    }
  }

  static Future<List<ConversationMessageModel>> getTextReponse(
      BuildContext context, String prompt) async {
    final palmSettingProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentModel = palmSettingProvider.getCurrentModel;
    var baseURL = palmSettingProvider.getBaseURL;
    var apiKey = palmSettingProvider.getApiKey;
    try {
      log("start, model: $currentModel, prompt: $prompt");
      log("$baseURL/models/$currentModel:generateText?key=$apiKey");
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse("$baseURL/models/$currentModel:generateText?key=$apiKey"));
      request.body = json.encode({
        "prompt": {"text": prompt},
        "temperature": 0.7,
        "top_k": 40,
        "top_p": 0.95,
        "candidate_count": 1,
        "max_output_tokens": 1024,
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

      List<ConversationMessageModel> chatList = [];
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var resp = await response.stream.bytesToString();
        log("resp $resp");
        Map jsonResponse = jsonDecode(resp);
        log("jsonResponse $jsonResponse");
        chatList = List.generate(
            jsonResponse["candidates"].length,
            (index) => ConversationMessageModel(
                msg: jsonResponse["candidates"][0]["output"], chatIndex: 1));
      } else {
        var message = response.reasonPhrase;
        throw HttpException(message!);
      }
      return chatList;
    } catch (error) {
      log("error, $error");
      rethrow;
    }
  }
}
