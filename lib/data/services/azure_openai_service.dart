import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import "package:http/http.dart" as http;
import 'package:moli_ai/core/constants/api_constants.dart';
import 'package:moli_ai/data/models/error_resp.dart';
import 'package:moli_ai/domain/inputs/ai_config_input.dart';

import '../../core/constants/constants.dart';
import '../../domain/dto/azure_openai_dto.dart';

class AzureOpenAIApiService {
  final AIApiConfigInput apiConfig;

  AzureOpenAIApiService({required this.apiConfig});

  static List<String> getModels() {
    try {
      return modelsList;
    } catch (error) {
      log("error, $error");
      throw HttpException("$error");
    }
  }

  static Future<AzureOpenAIChatMessageResp> getChatReponse(
      AzureOpenAIMessageReq req) async {
    var currentModel = req.modelName;
    var baseURL = req.basicUrl;
    var apiKey = req.apiKey;
    var apiVersion = req.apiVersion;
    try {
      // log("start, model: $currentModel, prompt: $context");
      var url =
          "$baseURL/openai/deployments/$currentModel/chat/completions?api-version=$apiVersion";
      log(url);
      var headers = {'Content-Type': 'application/json', "api-key": apiKey};
      log("$headers");
      log(apiKey);
      var request = http.Request('POST', Uri.parse(url));
      var message = '';
      for (var i = 0; i < req.messages.length; i++) {
        if (req.messages[i].role == roleAI) {
          continue;
        }
        message += "${req.messages[i].content}\n";
      }
      var messageLength = utf8.encode(message).length;
      request.body = json.encode({
        "messages": req.messages,
        "temperature": 0.7,
        "top_p": 0.95,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "max_tokens": 4096 - messageLength * 2,
        "stop": null
      });
      log(request.body);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404) {
        var resp = await response.stream.bytesToString();
        log("resp >> $resp <<");
        Map<String, dynamic> jsonResponse = jsonDecode(resp);
        // log("jsonResponse $jsonResponse");
        return AzureOpenAIChatMessageResp.fromJson(jsonResponse);
      } else {
        var resp = await response.stream.bytesToString();
        log(resp.toString());
        return AzureOpenAIChatMessageResp(
            error: ErrorResp(code: -1, message: "Bad Request", status: ""));
      }
    } catch (error) {
      log("catch error, $error");
      return AzureOpenAIChatMessageResp(
          error: ErrorResp(code: -1, message: error.toString(), status: ""));
    }
  }

  Future<AzureOpenAIChatMessageResp> completions(
      AzureOpenAIMessageReq req) async {
    var currentModel = apiConfig.modelName;
    var baseURL = apiConfig.basicUrl;
    var apiKey = apiConfig.apiKey;
    var apiVersion = AZURE_DEFAULT_API_VERSION;
    try {
      // log("start, model: $currentModel, prompt: $context");
      var url =
          "$baseURL/openai/deployments/$currentModel/chat/completions?api-version=$apiVersion";
      log(url);
      var headers = {'Content-Type': 'application/json', "api-key": apiKey};
      // log("$headers");
      var request = http.Request('POST', Uri.parse(url));
      var message = '';
      for (var i = 0; i < req.messages.length; i++) {
        // if (req.messages[i].role == roleAI) {
        //   continue;
        // }
        message += "${req.messages[i].content}\n";
      }
      var messageLength = utf8.encode(message).length;
      request.body = json.encode({
        "messages": req.messages,
        "temperature": 0.7,
        "top_p": 0.95,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "max_tokens": 4096 - messageLength * 2,
        "stop": null
      });
      // log(request.body);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 404) {
        var resp = await response.stream.bytesToString();
        log("resp >> $resp <<");
        Map<String, dynamic> jsonResponse = jsonDecode(resp);
        // log("jsonResponse $jsonResponse");
        return AzureOpenAIChatMessageResp.fromJson(jsonResponse);
      } else {
        var resp = await response.stream.bytesToString();
        log(resp.toString());
        return AzureOpenAIChatMessageResp(
            error: ErrorResp(code: -1, message: "Bad Request", status: ""));
      }
    } catch (error) {
      log("catch error, $error");
      return AzureOpenAIChatMessageResp(
          error: ErrorResp(code: -1, message: error.toString(), status: ""));
    }
  }
}
