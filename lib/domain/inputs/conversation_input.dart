class ChatListInput {
  int pageSize;
  int pageNum;

  ChatListInput({
    required this.pageSize,
    required this.pageNum,
  });

  Map<String, dynamic> toMap() {
    return {
      "pageSize": pageSize,
      "pageNum": pageNum,
    };
  }

  ChatListInput copy() {
    return ChatListInput(
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }
}

class ChatDeleteInput {
  int chatId;

  ChatDeleteInput({
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
    };
  }

  ChatDeleteInput copy() {
    return ChatDeleteInput(
      chatId: chatId,
    );
  }
}
