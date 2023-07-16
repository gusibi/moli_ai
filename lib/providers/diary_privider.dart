import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/conversation_model.dart';

class DiaryProvider with ChangeNotifier {
  ConversationModel currentDiaryInfo = newDiaryConversation;

  ConversationModel get getTodayDiary {
    return currentDiaryInfo;
  }

  void setCurrentDiaryInfo(ConversationModel newDiaryConversation) {
    currentDiaryInfo = newDiaryConversation;
    notifyListeners();
  }

  List<ConversationModel> diaryList = [newDiaryConversation];

  List<ConversationModel> get getDiaryList {
    return diaryList;
  }

  void setDiaryList(List<ConversationModel> newDiary) {
    diaryList = newDiary;
    notifyListeners();
  }
}
