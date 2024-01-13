class ChatMessageListInput {
  int pageSize;
  int pageNum;
  int chatId;

  ChatMessageListInput({
    required this.chatId,
    required this.pageSize,
    required this.pageNum,
  });

  Map<String, dynamic> toMap() {
    return {
      "pageSize": pageSize,
      "pageNum": pageNum,
    };
  }

  ChatMessageListInput copy() {
    return ChatMessageListInput(
      chatId: chatId,
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }
}

class ChatMessageCreateInput {
  int chatId;
  String message;
  String role;

  ChatMessageCreateInput({
    required this.chatId,
    required this.message,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "message": message,
      "role": role,
    };
  }

  ChatMessageCreateInput copy() {
    return ChatMessageCreateInput(
      chatId: chatId,
      message: message,
      role: role,
    );
  }
}
