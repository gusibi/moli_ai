import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/api_constants.dart';
import '../constants/constants.dart';
import '../models/chat_list_model.dart';
import '../services/palm_api_service.dart';

class PalmSettingProvider with ChangeNotifier {
  String currentModel = "text-bison-001";
  String apiKey = API_KEY;
  int chatId = 0;

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
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

  int get getChatId {
    return chatId;
  }

  void setChatId(int newChatId) {
    chatId = newChatId;
    notifyListeners();
  }

  ConversationCardDto currentChatInfo = defaultChat;

  ConversationCardDto get getCurrentChatInfo {
    return currentChatInfo;
  }

  void setCurrentChatInfo(ConversationCardDto newChatInfo) {
    currentChatInfo = newChatInfo;
    notifyListeners();
  }

  List<ConversationCardDto> chatList = [defaultChat];

  List<ConversationCardDto> get getChatList {
    return chatList;
  }

  void setChatList(List<ConversationCardDto> newChatList) {
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

  // new chat

  String currentChatTitle = "";

  String get getCurrentChatTitle {
    return currentChatTitle;
  }

  void setCurrentChatTitle(String newTitle) {
    currentChatTitle = newTitle;
    notifyListeners();
  }

  String currentChatPrompt = "";

  String get getCurrentChatPrompt {
    return currentChatPrompt;
  }

  void setCurrentChatPrompt(String newPrompt) {
    currentChatPrompt = newPrompt;
    notifyListeners();
  }

  Database? sqliteClient = null;

  Database? getSqliteClient() {
    return sqliteClient;
  }

  Future<void> setSqliteClient(Database client) async {
    sqliteClient = client;
    notifyListeners();
  }
}
