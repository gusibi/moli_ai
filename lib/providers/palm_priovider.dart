import 'package:flutter/material.dart';

import '../constants/api_constants.dart';
import '../services/palm_api_service.dart';

class PalmSettingProvider with ChangeNotifier {
  String currentModel = "text-bison-001";
  String baseURL = BASE_URL;
  String apiKey = API_KEY;

  String get getCurrentModel {
    return currentModel;
  }

  String get getBaseURL {
    return baseURL;
  }

  String get getApiKey {
    return apiKey;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  void setBaseURL(String newBaseURL) {
    baseURL = newBaseURL;
    notifyListeners();
  }

  void setApiKey(String newApiKey) {
    apiKey = newApiKey;
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
