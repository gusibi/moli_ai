class ConversationMessageModel {
  int id;
  final int conversationId;
  final String role;
  final String message;
  final int replyId;
  final int vote;
  final String ctime;

  ConversationMessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.message,
    required this.replyId,
    required this.vote,
    required this.ctime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role,
      "message": message,
      "replyId": replyId,
      "vote": vote,
      "ctime": ctime
    };
  }
}

class ChatModel {
  int id;
  String title;
  String convType;
  String prompt;
  String desc;
  int icon;
  int rank;
  String modelName;
  String? config;
  int lastTime;
  int memeoryCount;

  ChatModel(
      {required this.id,
      required this.title,
      required this.prompt,
      required this.convType,
      required this.desc,
      required this.icon,
      required this.rank,
      required this.modelName,
      this.config,
      required this.lastTime,
      this.memeoryCount = 6});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "prompt": prompt,
      "convType": convType,
      "desc": desc,
      "icon": icon,
      "rank": rank,
      "modelName": modelName,
      "config": config,
      "lastTime": lastTime
    };
  }

  ChatModel copy() {
    return ChatModel(
      id: id,
      title: title,
      convType: convType,
      desc: desc,
      icon: icon,
      prompt: prompt,
      modelName: modelName,
      config: config,
      rank: rank,
      lastTime: lastTime,
    );
  }
}
