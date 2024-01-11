import 'package:flutter/material.dart';
import 'package:moli_ai/domain/entities/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';

class ChatProvider with ChangeNotifier {
  List<ChatEntity> chatList = [defaultChatEntity];
  ChatEntity currentChatInfo = defaultChatEntity;

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
}
