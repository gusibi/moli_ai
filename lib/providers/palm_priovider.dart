import 'package:flutter/material.dart';

import '../constants/api_constants.dart';
import '../constants/constants.dart';
import '../models/conversation_model.dart';
import '../services/palm_api_service.dart';

class PalmSettingProvider with ChangeNotifier {
  String defaultModel = "text-bison-001";
  String apiKey = API_KEY;

  String get getCurrentModel {
    return defaultModel;
  }

  void setCurrentModel(String newModel) {
    defaultModel = newModel;
    notifyListeners();
  }

  String baseURL = BASE_URL;

  String get getBaseURL {
    return baseURL;
  }

  void setBaseURL(String newBaseURL) {
    baseURL = newBaseURL;
    notifyListeners();
  }

  String get getApiKey {
    return apiKey;
  }

  void setApiKey(String newApiKey) {
    apiKey = newApiKey;
    notifyListeners();
  }

  ConversationModel currentConversationInfo = defaultConversation;

  ConversationModel get getCurrentConversationInfo {
    return currentConversationInfo;
  }

  void setCurrentConversationInfo(ConversationModel newConversation) {
    currentConversationInfo = newConversation;
    notifyListeners();
  }

  List<ConversationModel> conversationList = [defaultConversation];

  List<ConversationModel> get getConversationList {
    return conversationList;
  }

  void setConversationList(List<ConversationModel> newConvs) {
    conversationList = newConvs;
    notifyListeners();
  }

  List<String> modelsList = [];

  List<String> get getPalmModelsList {
    return modelsList;
  }

  List<String> getAllPalmModels() {
    modelsList = PalmApiService.getModels();
    return modelsList;
  }

  String currentConversationTitle = "";

  String get getCurrentConversationTitle {
    return currentConversationTitle;
  }

  void setCurrentConversationTitle(String newTitle) {
    currentConversationTitle = newTitle;
    notifyListeners();
  }

  String currentConversationPrompt = "";

  String get getCurrentConversationPrompt {
    return currentConversationPrompt;
  }

  void setCurrentConversationPrompt(String newPrompt) {
    currentConversationPrompt = newPrompt;
    notifyListeners();
  }
}
