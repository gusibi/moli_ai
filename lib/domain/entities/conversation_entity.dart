class ChatMessageEntity {
  int id;
  String message;
  final int conversationId;
  final String role;
  final int replyId;
  final int vote;
  final String ctime;

  ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.replyId,
    required this.vote,
    required this.ctime,
    required this.message,
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

  ChatMessageEntity copy() {
    return ChatMessageEntity(
      id: id,
      conversationId: conversationId,
      role: role,
      message: message,
      replyId: replyId,
      vote: vote,
      ctime: ctime,
    );
  }
}

class ChatEntity {
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

  ChatEntity(
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

  ChatEntity copy() {
    return ChatEntity(
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
