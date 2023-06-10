import 'dart:convert';

import "package:http/http.dart" as http;

import '../constants/constants.dart';

class PalmApiService {
  // static Future<void> getModels() async {
  //   try {
  //     return modelsList;
  //   } catch (error) {
  //     print("error $error");
  //   }
  // }

  static Future<void> getTextReponse(String model, String prompt) async {
    try {
      print("start, model: $model, prompt: $prompt");
      print(Uri.parse("$BASE_URL/models/$model:generateText?key=$API_KEY"));
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse("$BASE_URL/models/$model:generateText?key=$API_KEY"));
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

      print("send");
      Map jsonResponse = jsonDecode(await response.stream.bytesToString());
      print("jsonResponse $jsonResponse");
    } catch (error) {
      print("error, $error");
    }
  }
}
