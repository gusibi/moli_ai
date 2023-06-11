import 'package:flutter/material.dart';

import '../services/palm_api_service.dart';

class PalmModelsProvider with ChangeNotifier {
  String currentModel = "text-bison-001";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
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
