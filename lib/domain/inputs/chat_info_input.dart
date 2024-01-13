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

class ChatDetailInput {
  int chatId;

  ChatDetailInput({
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
    };
  }

  ChatDetailInput copy() {
    return ChatDetailInput(
      chatId: chatId,
    );
  }
}

class ChatCreateInput {
  String title;
  String convType;
  String prompt;
  String desc;
  int icon;
  String modelName;

  ChatCreateInput({
    required this.title,
    required this.prompt,
    required this.convType,
    required this.desc,
    required this.icon,
    required this.modelName,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "prompt": prompt,
      "convType": convType,
      "desc": desc,
      "icon": icon,
      "modelName": modelName,
    };
  }

  ChatCreateInput copy() {
    return ChatCreateInput(
      title: title,
      convType: convType,
      desc: desc,
      icon: icon,
      prompt: prompt,
      modelName: modelName,
    );
  }
}
