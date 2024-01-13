import 'package:flutter/material.dart';
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/domain/entities/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';

class ChatProvider with ChangeNotifier {
  String defaultAIModel = geminiProModel.modelName;
  List<ChatEntity> chatList = [defaultChatEntity];
  ChatEntity currentChatInfo = defaultChatEntity;
  List<ChatEntity> conversationList = [defaultChatEntity];

  List<ChatEntity> get getChatList {
    return chatList;
  }

  void setChatList(List<ChatEntity> convsList) {
    chatList = convsList;
    notifyListeners();
  }

  void setCurrentChatInfo(ChatEntity newChat) {
    currentChatInfo = newChat;
    notifyListeners();
  }

  void addNewChatToList(ChatEntity conv) {
    conversationList.insert(0, conv);
    notifyListeners();
  }

  void setCurrentModel(String newModel) {
    defaultAIModel = newModel;
    notifyListeners();
  }
}
