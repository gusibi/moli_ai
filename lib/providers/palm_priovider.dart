import 'package:flutter/material.dart';

import '../constants/api_constants.dart';
import '../constants/constants.dart';
import '../models/chat_list_model.dart';
import '../services/palm_api_service.dart';

class PalmSettingProvider with ChangeNotifier {
  String currentModel = "text-bison-001";
  String baseURL = BASE_URL;
  String apiKey = API_KEY;
  int chatId = 0;

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

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

  int get getChatId {
    return chatId;
  }

  void setChatId(int newChatId) {
    chatId = newChatId;
    notifyListeners();
  }

  ChatCardModel currentChatInfo = defaultChat;

  ChatCardModel get getChatInfo {
    return currentChatInfo;
  }

  void setChatInfo(ChatCardModel newChatInfo) {
    currentChatInfo = newChatInfo;
    notifyListeners();
  }

  List<ChatCardModel> chatList = [defaultChat];

  List<ChatCardModel> get getChatList {
    return chatList;
  }

  void setChatList(List<ChatCardModel> newChatList) {
    chatList = newChatList;
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
}
