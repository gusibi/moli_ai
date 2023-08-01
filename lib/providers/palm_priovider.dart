import 'package:flutter/material.dart';

import '../constants/api_constants.dart';
import '../constants/constants.dart';
import '../models/config_model.dart';
import '../models/conversation_model.dart';
import '../services/palm_api_service.dart';

class AISettingProvider with ChangeNotifier {
  String defaultPalmModel = "text-bison-001";
  String palmApiKey = PALM_API_KEY;

  String get getCurrentPalmModel {
    return defaultPalmModel;
  }

  void setCurrentPalmModel(String newModel) {
    defaultPalmModel = newModel;
    notifyListeners();
  }

  String basePalmURL = PALM_BASE_URL;

  String get getBasePalmURL {
    return basePalmURL;
  }

  void setBasePalmURL(String newBaseURL) {
    basePalmURL = newBaseURL;
    notifyListeners();
  }

  String get getPalmApiKey {
    return palmApiKey;
  }

  void setPalmApiKey(String newApiKey) {
    palmApiKey = newApiKey;
    notifyListeners();
  }

  PalmConfig palmAIConfig = defaultPalmConfig;

  PalmConfig get getPalmAIConfig {
    return palmAIConfig;
  }

  void setPalmAIConfig(PalmConfig config) {
    palmAIConfig = config;
    notifyListeners();
  }

  AzureOpenAIConfig azureOpenAIConfig = defaultAzureOpenAIConfig;

  AzureOpenAIConfig get getAuzreOpenAIConfig {
    return azureOpenAIConfig;
  }

  void setAzureOpenAIConfig(AzureOpenAIConfig config) {
    azureOpenAIConfig = config;
    notifyListeners();
  }

  String defaultDiaryAI = defaultAIPalm;

  String get getDiaryAI {
    return defaultDiaryAI;
  }

  void setDiaryAI(String ai) {
    defaultDiaryAI = ai;
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
