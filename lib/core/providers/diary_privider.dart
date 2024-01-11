import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../../data/models/conversation_model.dart';

class DiaryProvider with ChangeNotifier {
  ChatModel currentDiaryInfo = newDiaryConversation;

  ChatModel get getTodayDiary {
    return currentDiaryInfo;
  }

  void setCurrentDiaryInfo(ChatModel newDiaryConversation) {
    currentDiaryInfo = newDiaryConversation;
    notifyListeners();
  }

  List<ChatModel> diaryList = [newDiaryConversation];

  List<ChatModel> get getDiaryList {
    return diaryList;
  }

  void setDiaryList(List<ChatModel> newDiary) {
    diaryList = newDiary;
    notifyListeners();
  }
}
