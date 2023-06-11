import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/palm_priovider.dart';

class PalmApiService {
  static List<String> getModels() {
    try {
      return modelsList;
    } catch (error) {
      print("error, $error");
      throw HttpException("$error");
    }
  }

  static Future<void> getTextReponse(
      BuildContext context, String prompt) async {
    final palmSettingProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentModel = palmSettingProvider.getCurrentModel;
    var baseURL = palmSettingProvider.getBaseURL;
    var apiKey = palmSettingProvider.getApiKey;
    try {
      print("start, model: $currentModel, prompt: $prompt");
      print(
          Uri.parse("$baseURL/models/$currentModel:generateText?key=$apiKey"));
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

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var message = await response.stream.bytesToString();
        print("send $message");
        Map jsonResponse = jsonDecode(message);
        print("jsonResponse $jsonResponse");
      } else {
        var message = response.reasonPhrase;
        throw HttpException(message!);
      }
    } catch (error) {
      print("error, $error");
    }
  }
}
