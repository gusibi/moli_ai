import 'package:flutter/material.dart';
import 'package:moli_ai/domain/entities/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';

class ConversationProvider with ChangeNotifier {
  List<ConversationEntity> conversationList = [defaultConvEntity];

  List<ConversationEntity> get getConversationList {
    return conversationList;
  }

  void setConversationList(List<ConversationEntity> convsList) {
    conversationList = convsList;
    notifyListeners();
  }
}
